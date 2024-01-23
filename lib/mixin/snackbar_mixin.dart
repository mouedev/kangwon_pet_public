import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../globals.dart';

mixin snackBarMixin{
  _showSnackBar(String message){
    BuildContext? context = globalKey.currentContext;
    if(context == null){
      return;
    }

    TextStyle? textStyle = Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white);
    SnackBar snackBar = SnackBar(
      content: Text(message, textAlign: TextAlign.center, style: textStyle),
    );
    globalKey.currentState?.showSnackBar(snackBar);
  }

  showLastListItemSnackBar(){
    BuildContext? context = globalKey.currentContext;
    if(context == null){
      return;
    }

    String message = AppLocalizations.of(context)?.thisIsLastItem ?? "This is the last item";
    _showSnackBar(message);
  }

  showFailedToLoadContentList(){
    BuildContext? context = globalKey.currentContext;
    if(context == null){
      return;
    }

    String message = AppLocalizations.of(context)?.failedToLoadContentList ?? "Failed to load the content list. Please check the network status.";
    _showSnackBar(message);
  }

  showFailedToLoadContentDetail(String title){
    BuildContext? context = globalKey.currentContext;
    if(context == null){
      return;
    }

    String message = AppLocalizations.of(context)?.failedToLoadContentDetail(title) ?? "$title Failed to load the content list. Please check the network status.";
    _showSnackBar(message);
  }
}