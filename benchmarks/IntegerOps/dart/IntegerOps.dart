// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Regression benchmark for https://github.com/dart-lang/sdk/issues/64209:
// int.toDouble() of Smi and Mint values, for int and num receivers.

import 'package:benchmark_harness/benchmark_harness.dart';

const int n = 1024;

abstract class ToDoubleBench extends BenchmarkBase {
  ToDoubleBench(String name) : super('IntegerOps.$name');

  final List<int> smis = List<int>.generate(n, (i) => i);
  final List<int> mints = List<int>.generate(n, (i) => 0x4000000000000000 + i);
  late final List<num> numSmis = List<num>.of(smis);
  late final List<num> numMints = List<num>.of(mints);
  double sink = 0;

  @override
  void teardown() {
    if (sink == 0) throw StateError('unreachable');
  }
}

class SmiToDouble extends ToDoubleBench {
  SmiToDouble() : super('smiToDouble');
  @override
  void run() {
    for (int i = 0; i < n; i++) {
      sink += smis[i].toDouble();
    }
  }
}

class MintToDouble extends ToDoubleBench {
  MintToDouble() : super('mintToDouble');
  @override
  void run() {
    for (int i = 0; i < n; i++) {
      sink += mints[i].toDouble();
    }
  }
}

class NumSmiToDouble extends ToDoubleBench {
  NumSmiToDouble() : super('numSmiToDouble');
  @override
  void run() {
    for (int i = 0; i < n; i++) {
      sink += numSmis[i].toDouble();
    }
  }
}

class NumMintToDouble extends ToDoubleBench {
  NumMintToDouble() : super('numMintToDouble');
  @override
  void run() {
    for (int i = 0; i < n; i++) {
      sink += numMints[i].toDouble();
    }
  }
}

void main() {
  final benchmarks = <BenchmarkBase Function()>[
    SmiToDouble.new,
    MintToDouble.new,
    NumSmiToDouble.new,
    NumMintToDouble.new,
  ];

  for (final bm in benchmarks) {
    bm().report();
  }
}
