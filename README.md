Easy to use, tiny Time library for when you just need time without all that DateTime nonsense.

## Features

- Conversion to and from `String`s
- Conversion to and from milliseconds as `int`s
- Addition and subtraction

## Getting started

To get started, simply import the library with `import 'package:eztime/eztime.dart'`
and create a `Time` object
```dart
var t = Time.fromString("12:00:00");
// or
var t = Time.fromMilliseconds(43200000); // 12 hours
// or
var t = Time(12, 00, 00) 
``` 

## Usage

Addition and subtraction
```dart
Time(12) + Time(0, 30); // 12:30:00
Time(10) - Time(5); // 05:00:00
Time(10, 0, 0, true) + Time(5); // -10:00:00 + 05:00:00 = -05:00:00
```

Conversion to and from more familiar formats
```dart
print(Time.fromString("00:30:00").toString()); // 00:30:00
print(Time(0, 1, 5).asMilliseconds); // 65000
```

## Additional information

Source code found at https://github.com/jaq-the-cat/eztime. Contribute at any time with anything,
I'm pretty much always on GitHub :P