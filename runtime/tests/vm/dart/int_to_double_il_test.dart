// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Verifies that int.toDouble() is inlined as Int64ToDouble.

import 'package:vm/testing/il_matchers.dart';

@pragma('vm:never-inline')
@pragma('vm:testing:print-flow-graph')
double toDouble(int x) => x.toDouble();

void main() {
  toDouble(int.parse('1'));
  toDouble(int.parse('1770000000000'));
}

void matchIL$toDouble(FlowGraph graph) {
  if (is32BitConfiguration) {
    return;
  }
  graph.match([
    match.block('Graph'),
    match.block('Function', [
      'x' << match.Parameter(index: 0),
      'result' << match.Int64ToDouble('x'),
      match.DartReturn('result'),
    ]),
  ]);
}
