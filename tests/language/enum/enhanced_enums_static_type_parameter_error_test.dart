// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

enum E<T> {
  a<int>(1);

  final T v;
  const E(this.v);

  static T? f;
  //     ^
  // [analyzer] COMPILE_TIME_ERROR.TYPE_PARAMETER_REFERENCED_BY_STATIC
  // [cfe] Type variables can't be used in static members.

  static T g(T t) => t;
  //     ^
  // [analyzer] COMPILE_TIME_ERROR.TYPE_PARAMETER_REFERENCED_BY_STATIC
  // [cfe] Type variables can't be used in static members.
  //         ^
  // [analyzer] COMPILE_TIME_ERROR.TYPE_PARAMETER_REFERENCED_BY_STATIC
  // [cfe] Type variables can't be used in static members.

  static List<T> get h => [];
  //          ^
  // [analyzer] COMPILE_TIME_ERROR.TYPE_PARAMETER_REFERENCED_BY_STATIC
  // [cfe] Type variables can't be used in static members.

  static set i(T t) {}
  //           ^
  // [analyzer] COMPILE_TIME_ERROR.TYPE_PARAMETER_REFERENCED_BY_STATIC
  // [cfe] Type variables can't be used in static members.

  static Object? j() {
    final T? t = null;
    //    ^
    // [analyzer] COMPILE_TIME_ERROR.TYPE_PARAMETER_REFERENCED_BY_STATIC
    // [cfe] Type variables can't be used in static members.
    return t;
  }
}

void main() {}
