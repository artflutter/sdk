// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:expect/expect.dart';
import 'package:expect/variations.dart' show jsNumbers;

const expected = [0xFF, 0, 0, 0, 0, 0xFF, 0, 0, 0, 0, 0, 0, 0, 0, 0, 44];

void checkByteData(String name, ByteBuffer buffer) {
  final data = buffer.asByteData();
  data.setUint8(0, -1);
  data.setUint8(5, 0x1FF);
  data.setUint8(10, 0x100);
  data.setUint8(15, 300);
  Expect.listEquals(expected, buffer.asUint8List(), name);
}

void checkUint8View(String name, ByteBuffer buffer) {
  final view = buffer.asUint8List();
  view[0] = -1;
  view.setRange(5, 6, [0x1FF]);
  view.setAll(10, [0x100]);
  view.fillRange(15, 16, 300);
  Expect.listEquals(expected, view, name);
}

void main() {
  checkByteData('ByteData', ByteData(16).buffer);
  checkByteData('Int16List', Int16List(8).buffer);
  checkByteData('Int32List', Int32List(4).buffer);
  checkByteData('Float32List', Float32List(4).buffer);
  checkByteData('Float64List', Float64List(2).buffer);
  checkByteData('Int32x4List', Int32x4List(1).buffer);

  checkUint8View('Uint8List', Uint8List(16).buffer);
  checkUint8View('Int16List', Int16List(8).buffer);
  checkUint8View('Int32List', Int32List(4).buffer);
  checkUint8View('Float32List', Float32List(4).buffer);
  checkUint8View('Float64List', Float64List(2).buffer);
  checkUint8View('Int32x4List', Int32x4List(1).buffer);

  if (!jsNumbers) {
    checkByteData('Int64List', Int64List(2).buffer);
    checkUint8View('Int64List', Int64List(2).buffer);
  }
}
