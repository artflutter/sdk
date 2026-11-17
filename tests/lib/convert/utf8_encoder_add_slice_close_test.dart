// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import "dart:convert";

import "package:expect/expect.dart";

// Regression test for https://github.com/dart-lang/sdk/issues/64949.

void main() {
  final long = 'x' * 3000;

  // isLast closes once.
  check(utf8.encode('abc'), (s) => s.addSlice('abc', 0, 3, true));

  // Empty last slice.
  check([], (s) => s.addSlice('', 0, 0, true));

  // Input spans several output buffers.
  check(utf8.encode(long), (s) => s.addSlice(long, 0, long.length, true));

  // Trailing lead surrogate becomes U+FFFD.
  check(utf8.encode('a\uD800'), (s) => s.addSlice('a\uD800', 0, 2, true));

  // Carried lead surrogate flushed by close().
  check(utf8.encode('a\uD83D'), (s) {
    s.addSlice('a\uD83D', 0, 2, false);
    s.close();
  });
}

void check(List<int> expected, void Function(StringConversionSink) feed) {
  var closes = 0;
  List<int>? bytes;
  final sink = utf8.encoder.startChunkedConversion(
    ChunkedConversionSink<List<int>>.withCallback((chunks) {
      closes++;
      bytes = [for (final chunk in chunks) ...chunk];
    }),
  );
  feed(sink);
  Expect.equals(1, closes);
  Expect.listEquals(expected, bytes!);
}
