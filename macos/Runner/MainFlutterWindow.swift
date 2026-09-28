import Cocoa
import FlutterMacOS
import Foundation
import IOKit
import IOKit.ps

class MainFlutterWindow: NSWindow {
  private let batteryEventHandler = BatteryEventHandler()
  private var updateTimer: Timer?
  private var powerSourceRunLoopSource: Unmanaged<CFRunLoopSource>?

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    let batteryChannel = FlutterMethodChannel(
      name: "com.example.mac_battery_full",
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )

    // Gardé pour un "pull" manuel (bouton Réessayer, chargement initial)
    batteryChannel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "getCompleteData" else {
        result(FlutterMethodNotImplemented)
        return
      }
      if let data = self?.getCombinedBatteryDetails() {
        result(data)
      } else {
        result(
          FlutterError(
            code: "BATTERY_ERROR", message: "Impossible de récupérer les données", details: nil))
      }
    }

    let batteryEventChannel = FlutterEventChannel(
      name: "com.batterykeep.battery.events",
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    batteryEventChannel.setStreamHandler(batteryEventHandler)

    super.awakeFromNib()
    startMonitoring()
  }

  // MARK: - Monitoring (push automatique, plus besoin de Timer côté Dart)

  private func startMonitoring() {
    // Rafraîchissement périodique léger : lecture IOKit ~instantanée, aucun risque de gel
    updateTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
      self?.pushUpdate()
    }

    // Notification native immédiate dès qu'une source d'énergie change (branché/débranché...)
    let context = Unmanaged.passUnretained(self).toOpaque()
    let callback: IOPowerSourceCallbackType = { context in
      guard let context = context else { return }
      Unmanaged<MainFlutterWindow>.fromOpaque(context).takeUnretainedValue().pushUpdate()
    }
    if let source = IOPSNotificationCreateRunLoopSource(callback, context)?.takeRetainedValue() {
      CFRunLoopAddSource(CFRunLoopGetMain(), source, .defaultMode)
      powerSourceRunLoopSource = Unmanaged.passRetained(source)
    }

    pushUpdate()  // premier envoi immédiat
  }

  private func pushUpdate() {
    guard let data = getCombinedBatteryDetails() else { return }
    batteryEventHandler.send(data)
  }

  // MARK: - Récupération des données (100% IOKit, aucun sous-processus)

  func getCombinedBatteryDetails() -> [String: Any]? {
    guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
      let sourcesList = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFDictionary]
    else { return nil }

    for source in sourcesList {
      guard let powerSource = source as? [String: Any],
        let type = powerSource[kIOPSTypeKey] as? String,
        type == kIOPSInternalBatteryType
      else { continue }

      var batteryData: [String: Any] = [:]

      let currentCapacity = powerSource[kIOPSCurrentCapacityKey] as? Int ?? 0
      let maxCapacity = powerSource[kIOPSMaxCapacityKey] as? Int ?? 0
      batteryData["currentCapacity"] = currentCapacity
      batteryData["maxCapacity"] = maxCapacity
      batteryData["percentage"] =
        maxCapacity > 0
        ? Int(round(Double(currentCapacity) / Double(maxCapacity) * 100)) : 0

      let isCharging = powerSource[kIOPSIsChargingKey] as? Bool ?? false
      let powerSourceState = powerSource[kIOPSPowerSourceStateKey] as? String ?? "Unknown"
      let isPluggedIn = powerSourceState.contains("AC")
      batteryData["isCharging"] = isCharging
      batteryData["isPluggedIn"] = isPluggedIn
      batteryData["powerSourceState"] = powerSourceState
      batteryData["name"] = powerSource[kIOPSNameKey] as? String ?? "Battery"

      var timeToEmpty = powerSource[kIOPSTimeToEmptyKey] as? Int ?? -1
      var timeToFull = powerSource[kIOPSTimeToFullChargeKey] as? Int ?? -1
      if isCharging && (timeToFull == 0 || timeToFull == -1) {
        timeToFull = max(1, (100 - currentCapacity) * 2)
      }
      if !isCharging && timeToEmpty <= 0 { timeToEmpty = -1 }
      batteryData["timeToEmpty"] = timeToEmpty
      batteryData["timeToFull"] = timeToFull
      batteryData["timeToEmptyFormatted"] = formatTimeWithNA(minutes: timeToEmpty)
      batteryData["timeToFullFormatted"] = formatTimeWithNA(minutes: timeToFull)

      if let smart = readAppleSmartBatteryProperties() {
        batteryData.merge(smart) { _, new in new }
      }

      if isCharging {
        batteryData["activeWattage"] = batteryData["chargerWattage"] ?? 0
        batteryData["wattageType"] = "charger"
      } else {
        batteryData["activeWattage"] = batteryData["liveWattage"] ?? 0.0
        batteryData["wattageType"] = "battery"
      }

      let currentPct = batteryData["percentage"] as? Int ?? 0
      if isCharging && currentPct >= 85 {
        batteryData["shouldUnplug"] = true
        batteryData["chargeAdviceMessage"] =
          "Votre batterie est déjà dans la fourchette qui peut être débranchée."
      } else if isCharging {
        batteryData["shouldUnplug"] = false
        batteryData["chargeAdviceMessage"] =
          "Continuez la charge, vous n'avez pas encore atteint la fourchette recommandée."
      } else {
        batteryData["shouldUnplug"] = false
        batteryData["chargeAdviceMessage"] =
          "Pour préserver la santé de votre batterie, il serait mieux de la brancher au moins dans les 20%."
      }

      return batteryData
    }
    return nil
  }
  private func readAppleSmartBatteryProperties() -> [String: Any]? {
    let service = IOServiceGetMatchingService(ioMainPort(), IOServiceMatching("AppleSmartBattery"))
    guard service != 0 else { return nil }
    defer { IOObjectRelease(service) }

    func topLevelProp(_ key: String) -> Any? {
      IORegistryEntryCreateCFProperty(service, key as CFString, kCFAllocatorDefault, 0)?
        .takeRetainedValue()
    }

    let nestedBatteryData = topLevelProp("BatteryData") as? [String: Any]
    func prop(_ key: String) -> Any? {
      topLevelProp(key) ?? nestedBatteryData?[key]
    }

    var result: [String: Any] = [:]

    if let temp = prop("Temperature") as? Int {
      result["temperature"] = Int(round(Double(temp) / 100.0))
      result["temperatureType"] = "battery"
    }
    if let cycleCount = prop("CycleCount") as? Int {
      result["cycleCount"] = cycleCount
    }

    // Wattage : valeur numérique BRUTE, pas de formatage ici (voir explication plus bas)
    if let voltage = prop("Voltage") as? Int, let amperage = prop("InstantAmperage") as? Int {
      result["liveWattage"] = abs(Double(voltage) * Double(amperage)) / 1_000_000.0

    }
    if let adapter = prop("AdapterDetails") as? [String: Any], let watts = adapter["Watts"] as? Int
    {
      result["chargerWattage"] = watts
    }

    if let manufactureDateRaw = prop("ManufactureDate") as? Int {
      let day = manufactureDateRaw & 0x1F
      let month = (manufactureDateRaw >> 5) & 0x0F
      let year = 1980 + ((manufactureDateRaw >> 9) & 0x7F)
      if month >= 1 && month <= 12 && day >= 1 && day <= 31 {
        result["manufactureDate"] = String(format: "%04d-%02d-%02d", year, month, day)
      }
    }

    // Santé = UNIQUEMENT l'usure (maxCap / designCap), rien à voir avec le niveau de charge actuel
    enum BatteryWearLevel {
      case excellent, good, normal, serviceRecommended, unknown

      var title: String {
        switch self {
        case .excellent: return "Excellente"
        case .good: return "Bon"
        case .normal: return "Normal"
        case .serviceRecommended: return "Révision conseillée"
        case .unknown: return "Diagnostic impossible"
        }
      }

      var description: String {
        switch self {
        case .excellent: return "Votre batterie est en excellente santé."
        case .good: return "Votre batterie est en bonne santé. Continuez vos bonnes habitudes."
        case .normal: return "Une légère usure est visible, rien d'inquiétant pour l'instant."
        case .serviceRecommended:
          return "La capacité maximale a nettement diminué. Un remplacement pourrait être envisagé."
        case .unknown: return "Impossible de lire l'état de la batterie de ce Mac."
        }
      }

      // Ordre du plus haut seuil au plus bas — c'est ce qui évite le bug d'origine
      static func from(percentage: Int) -> BatteryWearLevel {
        guard percentage > 0 && percentage <= 120 else { return .unknown }
        if percentage >= 90 { return .excellent }
        if percentage >= 80 { return .good }
        if percentage >= 65 { return .normal }
        return .serviceRecommended
      }
    }

    if let maxCap = prop("AppleRawMaxCapacity") as? Int,
      let designCap = prop("DesignCapacity") as? Int, designCap > 0
    {
      let healthPct = Int(round((Double(maxCap) / Double(designCap)) * 100))
      let wear = BatteryWearLevel.from(percentage: healthPct)
      result["health"] = wear.title
      result["healthDescription"] = wear.description
      result["healthPercentage"] = healthPct
    } else {
      result["health"] = BatteryWearLevel.unknown.title
      result["healthDescription"] = BatteryWearLevel.unknown.description
    }

    return result.isEmpty ? nil : result
  }

  func formatTimeWithNA(minutes: Int) -> String {
    guard minutes > 0 else { return "N/A" }
    return String(format: "%02dh %02dmin", minutes / 60, minutes % 60)
  }

  private func ioMainPort() -> mach_port_t {
    if #available(macOS 12.0, *) {
      return kIOMainPortDefault
    } else {
      return kIOMasterPortDefault
    }
  }

  deinit {
    updateTimer?.invalidate()
    if let source = powerSourceRunLoopSource {
      CFRunLoopRemoveSource(CFRunLoopGetMain(), source.takeUnretainedValue(), .defaultMode)
      source.release()
    }
  }
}
