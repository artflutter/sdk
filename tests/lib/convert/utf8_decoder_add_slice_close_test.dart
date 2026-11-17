// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import "dart:convert";

import "package:expect/expect.dart";

// Regression test for https://github.com/dart-lang/sdk/issues/64951.

void main() {
  final unfinished = [0x61, 0xE2, 0x82];

  // isLast delivers the text once.
  Expect.equals('a€', decode(utf8.decoder, [0x61, 0xE2, 0x82, 0xAC]));

  // isLast rejects an unfinished sequence.
  Expect.throwsFormatException(() => decode(utf8.decoder, unfinished));

  // isLast replaces an unfinished sequence when malformed input is allowed.
  const malformed = Utf8Decoder(allowMalformed: true);
  Expect.equals('a�', decode(malformed, unfinished));
}

String? decode(Utf8Decoder decoder, List<int> bytes) {
  var closes = 0;
  String? text;
  final sink = decoder.startChunkedConversion(
    ChunkedConversionSink<String>.withCallback((chunks) {
      closes++;
      text = chunks.join();
    }),
  );
  sink.addSlice(bytes, 0, bytes.length, true);
  Expect.equals(1, closes);
  return text;
}
