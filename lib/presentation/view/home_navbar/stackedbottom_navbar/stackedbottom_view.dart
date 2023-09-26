import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';


import '../../profile/profile_view.dart';
import '../../ride/ride_view.dart';
import '../../bus/bus/bus_view.dart';
import 'stackedbottom_viewmodel.dart';


class StackedBottomNavView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StackedBottomNavViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.transparent,
        body: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 300),
          reverse: model.reverse,
          transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              ) {
            return SharedAxisTransition(
              child: child,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
            );
          },
          child: getViewForIndex(model.currentIndex),
        ),

        bottomNavigationBar: Container(

          decoration: BoxDecoration(
            //borderRadius: BorderRadius.only(
                //topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black87.withOpacity(0.1), spreadRadius: 0, blurRadius: 8),
            ],
          ),


          child: ClipRRect(
            borderRadius: BorderRadius.only(
              //topLeft: Radius.circular(15.0),
              //topRight: Radius.circular(15.0),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Theme.of(context).colorScheme.background,
              currentIndex: model.currentIndex,
              onTap: model.setIndex,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              iconSize: 15,
              items: [
                BottomNavigationBarItem(
                  icon: new Image.asset('assets/images/viellytabs 1 - 2.png',height: 35,width: 35,),
                  activeIcon: new Image.asset('assets/images/viellytabs 1 - 1.png',height: 35,width: 35,),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: new Image.asset('assets/images/viellytabs 2 - 2.png',height: 35,width: 35,),
                  activeIcon: new Image.asset('assets/images/viellytabs 2 - 1.png',height: 35,width: 35,),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: new Image.asset('assets/images/viellytabs 3 - 2.png',height: 35,width: 35,),
                  activeIcon: new Image.asset('assets/images/viellytabs 3 - 1.png',height: 35,width: 35,),

                  label: ''
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => StackedBottomNavViewModel(),
    );
  }
}

Widget getViewForIndex(int index) {
  switch (index) {
    case 0:
      return BusView();
    case 1:
      return RideView();
    case 3:
      return ProfileView();
    default:
      return ProfileView();
  }
}