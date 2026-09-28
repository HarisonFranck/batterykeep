import 'package:batterykeep/features/battery_monitor/data/models/BatterySample.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class BatteryHistoryService {
  Database? _db;

  Future<void> init() async {
    sqfliteFfiInit();
    final factory = databaseFactoryFfi;

    _db = await factory.openDatabase("atterykeep_history.db");

    await _db!.execute('''
    CREATE TABLE IF NOT EXISTS samples(
    timestamp INTEGER PRIMARY KEY,
    percentage INTEGER NOT NULL,
    is_charging INTEGER NOT NULL,
    is_plugged_in INTEGER NOT NULL
    ) 
''');

    await _db!.execute('''
      CREATE INDEX IF NOT EXISTS idx_timestamp ON samples(timestamp)
''');

    final cutoff = DateTime.now()
        .subtract(Duration(days: 30))
        .millisecondsSinceEpoch;

    await _db!.delete("samples", where: 'timestamp < ?', whereArgs: [cutoff]);
  }

  Future<void> addSample({
    required int percentage,
    required bool isCharging,
    required bool isPluggedIn,
  }) async {
    _db!.insert('samples', {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'percentage': percentage,
      'is_charging': isCharging ? 1 : 0,
      'is_plugged_in': isPluggedIn ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<BatterySample>> getLastHours(int hours) async {
    final since = DateTime.now()
        .subtract(Duration(hours: hours))
        .millisecondsSinceEpoch;
    final rows = await _db!.query(
      'samples',
      where: 'timestamp >= ?',
      whereArgs: [since],
      orderBy: 'timestamp ASC',
    );
    return rows.map(BatterySample.fromRow).toList();
  }

  // Durée totale passée en charge aujourd'hui
  Future<Duration> getTotalChargingTimeToday() async {
    final samples = await _getTodaySamples();
    return _sumIntervals(samples, (s) => s.isCharging);
  }

  // Temps passé entre 80% et 100%
  Future<Duration> getTimeInRangeToday(int min, int max) async {
    final samples = await _getTodaySamples();
    return _sumIntervals(
      samples,
      (s) => s.percentage >= min && s.percentage <= max,
    );
  }

  Future<List<BatterySample>> _getTodaySamples() async {
    final now = DateTime.now();
    final startOfDay = DateTime(
      now.year,
      now.month,
      now.day,
    ).millisecondsSinceEpoch;
    final rows = await _db!.query(
      'samples',
      where: 'timestamp >= ?',
      whereArgs: [startOfDay],
      orderBy: 'timestamp ASC',
    );
    return rows.map(BatterySample.fromRow).toList();
  }

  Duration _sumIntervals(
    List<BatterySample> samples,
    bool Function(BatterySample) predicate,
  ) {
    Duration total = Duration.zero;
    for (int i = 1; i < samples.length; i++) {
      if (predicate(samples[i - 1])) {
        total += samples[i].timestamp.difference(samples[i - 1].timestamp);
      }
    }
    return total;
  }

  Future<void> close() async {
    await _db?.close();
  }
}
