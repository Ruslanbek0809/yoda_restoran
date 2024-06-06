import 'dart:async';
import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> initializeSentry() async {
  const dsn =
      'https://0970828041c39d0abd6539f73ab490b4@o4505392038346752.ingest.sentry.io/4506648025104384';
  // final dsn = env.env == 'dev' ? 'WRONG_DSN_DISABLES_SENTRY_INITILIZATION' : 'ENTER_YOUR_SENTRY_URL';

  await SentryFlutter.init(
    (options) {
      options
        ..dsn = dsn
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        ..tracesSampleRate = 1.0;
    },
  );
}

void reportExceptionToSentry(Object error, {String? additionalInfo}) {
  Sentry.captureException(
    additionalInfo != null ? '$additionalInfo $error' : error,
  );
}

void reportExceptionToSentryWithStacktrace(
  Object error, {
  String? additionalInfo,
  StackTrace? stackTrace,
}) {
  Sentry.captureException(
    additionalInfo != null ? '$additionalInfo $error' : error,
    stackTrace: stackTrace,
  );
}

void reportDioExceptionToSentry(DioError error, {String? additionalInfo}) {
  Sentry.captureException(
    additionalInfo != null ? '$additionalInfo $error' : error,
    stackTrace: error.stackTrace,
  );
}
