import 'dart:async';

import 'package:deborah/utils/deb_get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final debgetVersionProvider = FutureProvider<String>((ref) {
  final version = Completer<String>();

  DebGet.run(
    ['version'],
    (line) {
      version.complete(line.trim());
    },
    null,
  );

  return version.future;
});
