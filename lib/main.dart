import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:global_navigator/global_navigator.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:static_i18n/static_i18n.dart';

import 'di/di_config.dart';
import 'presentation/app.dart';
import 'presentation/core/routes/navigator_key_holder.dart';
import 'presentation/i18n/app_locales.dart';
import 'presentation/i18n/app_translations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection(Environment.prod);

  StaticI18N.initialize(
    tr: getIt<AppTranslations>(),
    locale: AppLocales.defaultLocale,
    fallbackLocale: AppLocales.fallbackLocale,
  );

  GlobalNavigator.navigatorKey = NavigatorKeyHolder.navigatorKey;

  runApp(const App());

  VVOConfig.passwordVVOConfig.minLength = 4;
  VVOConfig.nameVVOConfig.minLength = 2;
}

final Logger logger = Logger();