import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

import 'getstarted_viewmodel.dart';
import '../../../../utilities/statusbar_util.dart';
import '../../../widgets/custom_widgets/button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GetStartedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<GetStartedViewModel>.reactive(
      viewModelBuilder: () => GetStartedViewModel(),
      builder: (context, model, child) =>
          StatusBarUtil.setStatusBarColorUtil(context,
            Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: SafeArea(
                child: Container(
                  height: size.height,
                  width: size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: size.width,
                        height: size.height - 350,
                        padding: EdgeInsets.all(100),
                        child: SvgPicture.asset('assets/images/curve_logo.svg',
                          height: 100,
                          width: 60,
                          //fit: BoxFit.contain,
                          //alignment: Alignment.bottomCenter,
                        ),
                      ),
                      Container(
                        width: size.width * 0.8,
                        margin: EdgeInsets.only(
                            bottom: 20),
                        child:
                        Button(
                          child:
                          Row(
                            mainAxisAlignment:  MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.getStarted,
                                style: Theme.of(context).textTheme.button,
                              ),
                            ],
                          ),
                          size: 45,
                          color: Theme.of(context).colorScheme.primary,
                          onPressed: () {

                            model.navigateToLogin();
                          },
                        ),
                      ),
                      Container(
                        width: size.width,
                        height: 240,
                        child: SvgPicture.asset(
                          'assets/icons/Layer_x0020_1dfr.svg',
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
}

