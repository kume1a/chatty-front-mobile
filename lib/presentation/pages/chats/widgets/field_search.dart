import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:static_i18n/static_i18n.dart';

import '../../../core/values/assets.dart';
import '../../../i18n/translation_keys.dart';

class FieldSearch extends StatelessWidget {
  const FieldSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: theme.colorScheme.primaryContainer,
      ),
      child: Row(
        children: <Widget>[
          SvgPicture.asset(
            Assets.iconSearch,
            width: 18,
            height: 18,
          ),
          const SizedBox(width: 8),
          Text(
            TkCommon.search.i18n,
            style: TextStyle(color: theme.secondaryHeaderColor),
          ),
        ],
      ),
    );
  }
}
