// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:expect/expect.dart';

void main() {
  final o = JSObject();
  o['n'] = null;
  o['x'] = 1.toJS;

  Expect.throwsTypeError(() => o.getProperty<JSNumber>('a'.toJS));
  Expect.throwsTypeError(() => o.getProperty<JSNumber>('n'.toJS));
  Expect.isNull(o.getProperty<JSNumber?>('a'.toJS));
  Expect.isNull(o.getProperty<JSNumber?>('n'.toJS));
  Expect.equals(1, o.getProperty<JSNumber>('x'.toJS).toDartInt);
}
