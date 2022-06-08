import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recycling/data/data_config_values.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPopup extends StatelessWidget {
  const PrivacyPopup(
      {Key? key,
      this.onAgree = defaultOnAgree,
      this.onDisagree = defaultOnDisagree})
      : super(key: key);

  final AsyncCallback onAgree;
  final AsyncCallback onDisagree;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        AppLocalizations.of(context)!.privacySettings,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Text(
        AppLocalizations.of(context)!.privacyPolicyPopupMessage,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            await onAgree();
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.agree),
        ),
        TextButton(
          onPressed: () async {
            await onDisagree();
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.disagree),
        ),
        TextButton(
          onPressed: () {
            launchUrl(
                Uri.parse(AppLocalizations.of(context)!.privacyPolicyUrl));
          },
          child: Text(AppLocalizations.of(context)!.moreInformation),
        ),
      ],
    );
  }

  static show(
      {required BuildContext context,
      AsyncCallback? onAgree,
      AsyncCallback? onDisagree}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PrivacyPopup(
          onAgree: onAgree ?? defaultOnAgree,
          onDisagree: onDisagree ?? defaultOnDisagree,
        );
      },
    );
  }

  static Future<void> defaultOnAgree() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPreferenceKeys.privacyAgree.name, true);
  }

  static Future<void> defaultOnDisagree() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPreferenceKeys.privacyAgree.name, false);
  }
}
