/// Limiter for use in fields with a maximum value
/// As an example, if you plug in an [n] of 25 and a [max] of 24, you will get
/// an [extra] of 1, 1 day, and a [remaining] of 1, 1 hour
class Limit {
  int _extra = 0;
  double _remaining = 0;
  Limit(num n, int max) {
    double v = n / max;
    _extra = v.truncate();
    _remaining = ((v - extra) * max);
  }

  int get extra => _extra;
  double get remaining => _remaining;

  @override
  String toString() {
    return "Limit<extra: $_extra, remaining: $_remaining>";
  }
}

double _msToHours(int ms) => ((ms / 60) / 60) / 1000;
String _intAsTime(int n) {
  return n.toString().padLeft(2, '0');
}

String _doubleAsTime(double n) {
  return n.toStringAsFixed(3).padLeft(6, '0');
}

/// Represents a Time in hours, minutes and seconds. Automatically wraps values, so both
/// Time(0, 60, 60) and Time(24, 60, 60) will return 01:01:00.
///
/// This class supports addition, subtraction and conversion to and from strings and milliseconds,
/// aswell as addition with days.
class Time {
  final bool negative;
  int _h = 0, _m = 0;
  double _s = 0;

  Time(int h, [int m = 0, double s = 0, this.negative = false]) {
    final os = Limit(s.abs(), 60);
    final om = Limit(m.abs() + os._extra, 60);
    final oh = Limit(h.abs() + om.extra, 24);

    _h = oh.remaining.round();
    _m = om._remaining.round();
    _s = os._remaining;
  }

  /// Return total time in milliseconds.
  /// 60 seconds would be 60,000 milliseconds.
  /// For milliseconds since epoch, you are looking for a `DateTime` object
  int get asMilliseconds =>
      (_s * 1000).round() + (_m * 60 * 1000) + (_h * 60 * 60 * 1000);

  Time get asNegative => Time(_h, _m, _s, true);

  /// Returns the sum of 2 times, with the number of days passed ommited.
  /// For that, look at [Time.addWithDays]
  Time operator +(Time other) {
    if (other.negative) {
      return this - other;
    } else if (negative) {
      return other - this;
    }
    return Time(_h + other._h, _m + other._m, _s + other._s, negative);
  }

  /// Returns the subtraction of 2 times.
  Time operator -(Time other) {
    int thisMs = negative ? -asMilliseconds : asMilliseconds;
    final ms = thisMs - other.asMilliseconds;
    final t = Time.fromMilliseconds(ms.abs())!;
    if (ms < 0) return t.asNegative;
    return t;
  }

  /// Adds two times and returns a list of [days, hours, minutes, seconds]
  /// If you want the addition without the number of days returned as a [Time] object,
  /// use the [+] operator
  List<num> addWithDays(Time other) {
    final s = Limit(_s + other._s, 60);
    final m = Limit(_m + other._m + s._extra, 60);
    final h = Limit(_h + other._h + m.extra, 24);
    return [h._extra, h._remaining.round(), m.remaining.round(), s._remaining];
  }

  /// Converts a string in the format HH:MM:SS to a [Time] object. If parsing fails,
  /// `null` is returned
  static Time? fromString(String asString) {
    final negative = asString[0] == '-';
    if (negative) asString = asString.substring(1);
    final split = asString.split(':');
    if (split.length != 3) return null;
    final h = int.tryParse(split[0])?.abs();
    final m = int.tryParse(split[1])?.abs();
    final s = double.tryParse(split[2])?.abs();
    if (h == null || m == null || s == null) return null;
    return Time(h, m, s, negative);
  }

  /// Converts an amount of milliseconds to a [Time] object, with the number of days
  /// ommited
  static Time? fromMilliseconds(int ms) {
    double h = _msToHours(ms).abs();
    int justH = h.truncate();
    double m = (h - justH) * 60;
    int justM = m.truncate();
    double s = (m - justM) * 60;

    return Time(justH, justM, s, ms < 0);
  }

  @override
  String toString() =>
      "${negative ? "-" : ""}${_intAsTime(_h)}:${_intAsTime(_m)}:${_doubleAsTime(_s)}";
}
