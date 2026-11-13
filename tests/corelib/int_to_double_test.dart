// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// VMOptions=
// VMOptions=--optimization_counter_threshold=20 --no-background-compilation

import 'package:expect/expect.dart';
import 'package:expect/variations.dart' show jsNumbers;

@pragma('vm:never-inline')
@pragma('dart2js:never-inline')
double intToDouble(int x) => x.toDouble();

@pragma('vm:never-inline')
@pragma('dart2js:never-inline')
double numToDouble(num x) => x.toDouble();

@pragma('vm:never-inline')
@pragma('dart2js:never-inline')
num add(num a, num b) => a + b;

@pragma('vm:never-inline')
@pragma('dart2js:never-inline')
num sub(num a, num b) => a - b;

@pragma('vm:never-inline')
@pragma('dart2js:never-inline')
num mul(num a, num b) => a * b;

@pragma('vm:never-inline')
@pragma('dart2js:never-inline')
num div(num a, num b) => a ~/ b;

@pragma('vm:never-inline')
@pragma('dart2js:never-inline')
num mod(num a, num b) => a % b;

@pragma('vm:never-inline')
@pragma('dart2js:never-inline')
num rem(num a, num b) => a.remainder(b);

void check(int x, double expected) {
  Expect.equals(expected, intToDouble(x));
  Expect.equals(expected, numToDouble(x));
  Expect.equals(-expected, intToDouble(-x));
  Expect.equals(-expected, numToDouble(-x));
}

void test() {
  check(0, 0.0);
  check(1, 1.0);
  check(0x3fffffff, 1073741823.0);
  check(0x40000000, 1073741824.0);
  check(0x40000001, 1073741825.0);
  check(0x7fffffff, 2147483647.0);
  check(0x80000000, 2147483648.0);
  check(0xffffffff, 4294967295.0);
  check(0x100000000, 4294967296.0);
  check(1770000000000, 1770000000000.0);
  check(0x1fffffffffffff, 9007199254740991.0);
  check(0x20000000000000, 9007199254740992.0);
  check(0x4000000000000000, 4611686018427387904.0);

  if (!jsNumbers) {
    check(int.parse('9007199254740993'), 9007199254740992.0);
    check(int.parse('9007199254740995'), 9007199254740996.0);
    check(int.parse('4611686018427387903'), 4611686018427387904.0);
    check(int.parse('9223372036854775807'), 9223372036854775808.0);
    Expect.equals(
      -9223372036854775808.0,
      intToDouble(int.parse('-9223372036854775808')),
    );
  }

  Expect.equals(2.5, numToDouble(2.5));

  Expect.equals(1073741824.5, add(0x40000000, 0.5));
  Expect.equals(1073741823.5, sub(0x40000000, 0.5));
  Expect.equals(536870912.0, mul(0x40000000, 0.5));
  Expect.equals(2147483648, div(0x40000000, 0.5));
  Expect.equals(0.25, mod(0x40000000, 0.75));
  Expect.equals(0.25, rem(0x40000000, 0.75));
}

void main() {
  for (var i = 0; i < 100; i++) {
    test();
  }
}
