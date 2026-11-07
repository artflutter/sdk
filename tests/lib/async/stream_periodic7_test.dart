// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:expect/expect.dart';

void main() {
  const period = Duration(hours: 1);
  const delay = Duration(milliseconds: 10);
  final timers = <Duration>[];
  runZoned(
    () {
      final subscription = Stream.periodic(period).listen(null);
      final watch = Stopwatch()..start();
      while (watch.elapsed < delay) {}
      subscription
        ..pause()
        ..resume()
        ..cancel();
    },
    zoneSpecification: ZoneSpecification(
      createTimer: (self, parent, zone, duration, callback) {
        timers.add(duration);
        return parent.createTimer(zone, duration, callback);
      },
    ),
  );
  Expect.isTrue(timers.single <= period - delay, '${timers.single}');
}
