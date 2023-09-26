import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';


import '../../home_navbar/bottom_navbar/bottom_navbar_viewmodel.dart';
import 'bottom_navbar_viewmodel.dart';
import 'tab_navigator.dart';


class BottomNavBarView extends StatefulWidget {


  @override
  _BottomNavBarViewState createState() => _BottomNavBarViewState();
}

class _BottomNavBarViewState extends State<BottomNavBarView> {
  String _currentPage = "Page2";

  List<String> pageKeys = ["Page1", "Page2", "Page3"];

  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Page1": GlobalKey<NavigatorState>(),
    "Page2": GlobalKey<NavigatorState>(),
    "Page3": GlobalKey<NavigatorState>(),
  };

  int _selectedIndex = 1;

  void _selectTab(String tabItem, int index) {
    if(tabItem == _currentPage ){
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BottomNavBarViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.transparent,
        body:
        Stack(
            children:<Widget>[
              _buildOffstageNavigator("Page1"),
              _buildOffstageNavigator("Page2"),
              _buildOffstageNavigator("Page3"),
            ]
        ),


        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            //borderRadius: BorderRadius.only(
            //topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black87.withOpacity(0.1), spreadRadius: 0, blurRadius: 8),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).colorScheme.background,
            currentIndex: _selectedIndex,
            onTap: (int index) { _selectTab(pageKeys[index], index); },
            iconSize: 15,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: new SvgPicture.asset('assets/icons/viellytabs 1 - 2.svg',height: 35,width: 35, color: Theme.of(context).colorScheme.onSurface,),
                activeIcon: new SvgPicture.asset('assets/icons/viellytabs 1 - 1.svg',height: 35,width: 35,),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: new SvgPicture.asset('assets/icons/viellytabs 2 - 2.svg',height: 35,width: 35, color: Theme.of(context).colorScheme.onSurface,),
                activeIcon: new SvgPicture.asset('assets/icons/viellytabs 2 - 1.svg',height: 35,width: 35,),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: new SvgPicture.asset('assets/icons/viellytabs 3 - 2.svg',height: 35,width: 35, color: Theme.of(context).colorScheme.onSurface,),
                activeIcon: new SvgPicture.asset('assets/icons/viellytabs 3 - 1.svg',height: 35,width: 35,),
                label: '',
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => BottomNavBarViewModel(),
    );
  }

Widget _buildOffstageNavigator(String tabItem) {
  return Offstage(
    offstage: _currentPage != tabItem,
    child: TabNavigator(
      navigatorKey: _navigatorKeys[tabItem]!,
      tabItem: tabItem,
    ),
  );
}

}


