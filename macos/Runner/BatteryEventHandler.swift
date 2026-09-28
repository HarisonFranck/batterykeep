import FlutterMacOS
import Foundation

class BatteryEventHandler: NSObject, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
    -> FlutterError?
  {
    self.eventSink = events
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }

  func send(_ data: [String: Any]) {
    DispatchQueue.main.async { [weak self] in
      self?.eventSink?(data)
    }
  }
}
