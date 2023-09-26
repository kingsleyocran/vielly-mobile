

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'splashscreen_viewmodel.dart';
import 'package:curve/utilities/statusbar_util.dart';

class SplashScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashScreenViewModel>.reactive(
      viewModelBuilder: () => SplashScreenViewModel(),
      onModelReady: (model) => model.startupLogic(),
      builder: (context, model, child) =>
          StatusBarUtil.setStatusBarColorUtil(context,
            Container(
                color: Theme.of(context).colorScheme.background,
                /*
                child: Center(
                  child: Container(
                    width: 130,
                    height: 230,
                    child: Center(child: SvgPicture.asset('assets/images/curve_logo.svg')),
                  ),

                 */
                )
            ),
          );
  }
}



