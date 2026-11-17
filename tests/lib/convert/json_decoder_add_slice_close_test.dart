// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import "dart:convert";

import "package:expect/expect.dart";

// Regression test for https://github.com/dart-lang/sdk/issues/64948.

void main() {
  // isLast delivers the result once.
  check([1, 2, 3], (s) => s.addSlice('[1, 2, 3]', 0, 9, true));

  // A top-level number is only complete at the end of the input.
  check(12, (s) {
    s.addSlice('1', 0, 1, false);
    s.addSlice('2', 0, 1, true);
  });

  // Incomplete input still throws.
  Expect.throwsFormatException(
    () => check(null, (s) => s.addSlice('[1, 2', 0, 5, true)),
  );
}

void check(Object? expected, void Function(StringConversionSink) feed) {
  var closes = 0;
  Object? result;
  final sink = json.decoder.startChunkedConversion(
    ChunkedConversionSink<Object?>.withCallback((values) {
      closes++;
      result = values.single;
    }),
  );
  feed(sink);
  Expect.equals(1, closes);
  Expect.deepEquals(expected, result);
}
