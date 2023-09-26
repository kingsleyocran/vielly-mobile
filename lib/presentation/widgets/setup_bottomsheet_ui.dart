import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:intl/intl.dart';
import '../../app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


enum BottomSheetType { basic, full, profilePic, busSchedule,busLane, busTerminal, busDate, busTime, tripSafety}

void setupBottomSheetUi() {
  final bottomSheetService = locator<BottomSheetService>();

  final builders = {
    BottomSheetType.basic: (context, sheetRequest, completer) =>
        _FloatingBoxBottomSheet(request: sheetRequest, completer: completer),

    BottomSheetType.profilePic: (context, sheetRequest, completer) =>
        ProfilePicBottomSheet(request: sheetRequest, completer: completer),

    BottomSheetType.busSchedule: (context, sheetRequest, completer) =>
        BusScheduleBottomSheet(request: sheetRequest, completer: completer,),

    BottomSheetType.busLane: (context, sheetRequest, completer) =>
        BusLaneBottomSheet(request: sheetRequest, completer: completer,),

    BottomSheetType.busTerminal: (context, sheetRequest, completer) =>
        BusTerminalBottomSheet(request: sheetRequest, completer: completer,),

    BottomSheetType.busDate: (context, sheetRequest, completer) =>
        BusDateBottomSheet(request: sheetRequest, completer: completer,),

    BottomSheetType.busTime: (context, sheetRequest, completer) =>
        BusDepartTimeBottomSheet(request: sheetRequest, completer: completer,),

    BottomSheetType.tripSafety: (context, sheetRequest, completer) =>
        SafetyBottomSheet(request: sheetRequest, completer: completer,),

  };

  bottomSheetService.setCustomSheetBuilders(builders);
}


//onTap: () => completer(SheetResponse(...));
//completer(SheetResponse(confirmed: true))
class ProfilePicBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;


  ProfilePicBottomSheet({
    Key? key,
    required this.request,
    required this.completer,

  }) : super(key: key);

  final ThemeService _themeService = locator<ThemeService>();
  ThemeService get getTheme => _themeService;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),

      ),
      child: Column(
        children: [
          //Header
          //Header
          Container(
            child: Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      SizedBox(
                        height: 26,
                        width: 26,
                      ),
                      Text(AppLocalizations.of(context)!.updateProfilePhoto,
                        style:
                        Theme.of(context).textTheme.headline6!.apply(color: (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                            ?
                        Theme.of(context).colorScheme.onSurface
                            :
                        Theme.of(context).colorScheme.onError
                        ),
                      ),
                      SizedBox(
                        height: 26,
                        width: 26,
                        child: RawMaterialButton(
                          padding: EdgeInsets.all(0),
                          elevation: 0,
                          fillColor: Theme.of(context).colorScheme.onSurface,
                          shape: CircleBorder(),
                          onPressed: (){
                            Navigator.pop(context);
                          },

                          child: Container(
                              padding: EdgeInsets.all(7),
                              child:
                              SvgPicture.asset('assets/icons/icon-close-back-black.svg',
                                color:  Theme.of(context).colorScheme.background,)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Divider(
                  color: Theme.of(context).colorScheme.surface,
                  thickness: 1,
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),

          //Content
          Container(
            padding: EdgeInsets.symmetric(vertical: 0),
            child: Column(
              children: [
                MaterialButton(
                  padding: EdgeInsets.all(0),
                  splashColor: Theme.of(context).colorScheme.onSurface,
                  onPressed: (){
                    completer(SheetResponse(data: 'Gallery'));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width*0.06,),
                    height: 60,
                    child: Row(
                      children: [
                        Container(
                          height: 27,
                          width: 27,
                          child: SvgPicture.asset('assets/icons/folder.svg',
                              color:
                              (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                  ?
                              Theme.of(context).colorScheme.onSecondary
                                  :
                              Theme.of(context).colorScheme.onBackground
                          ),
                        ),
                        SizedBox(width: 15,),
                        Text(AppLocalizations.of(context)!.pickFromPhotoAlbum,
                          style:
                          Theme.of(context).textTheme.bodyText1!.apply(
                              color:
                              (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                  ?
                              Theme.of(context).colorScheme.onSecondary
                                  :
                              Theme.of(context).colorScheme.onBackground
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10,),

                MaterialButton(
                  padding: EdgeInsets.all(0),
                  splashColor: Theme.of(context).colorScheme.onSurface,
                  onPressed: (){
                    completer(SheetResponse(data: 'Camera'));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width*0.06,),
                    height: 60,
                    child: Row(
                      children: [
                        Container(
                          height: 27,
                          width: 27,

                          child: SvgPicture.asset('assets/icons/camera.svg' ,
                              color:
                              (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                  ?
                              Theme.of(context).colorScheme.onSecondary
                                  :
                              Theme.of(context).colorScheme.onBackground
                          ),
                        ),
                        SizedBox(width: 15,),
                        Text( AppLocalizations.of(context)!.takeAPhoto,
                          style: Theme.of(context).textTheme.bodyText1!.apply(
                              color:
                              (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                  ?
                              Theme.of(context).colorScheme.onSecondary
                                  :
                              Theme.of(context).colorScheme.onBackground
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class BusScheduleBottomSheet extends StatefulWidget {
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final SheetRequest request;
  final Function(SheetResponse) completer;

  BusScheduleBottomSheet({
    Key? key,
    required this.request,
    required this.completer,

  }) : super(key: key);

  @override
  State<BusScheduleBottomSheet> createState() => _BusScheduleBottomSheetState();
}
class _BusScheduleBottomSheetState extends State<BusScheduleBottomSheet> {
  final ThemeService _themeService = locator<ThemeService>();

  ThemeService get getTheme => _themeService;

  DateTime tempPickedDate = DateTime.now();

  var opTimes = [
    "07:00 AM",
    "09:00 AM",
    "11:00 AM",
    "13:00 PM",
    "14:00 PM",
    "17:00 PM",
    "18:00 PM",
    "20:00 PM",
  ];

  String selectedOpTime = '07:00 AM';



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.9,
      width: size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),

      ),
      child: Column(
        children: [
          //Header
          Container(
            child: Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      SizedBox(
                        height: 26,
                        width: 26,
                      ),
                      Text('${widget.request.title}',
                        style:
                        Theme.of(context).textTheme.headline6!.apply(color: (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                            ?
                        Theme.of(context).colorScheme.onSurface
                            :
                        Theme.of(context).colorScheme.onError
                        ),
                      ),
                      SizedBox(
                        height: 26,
                        width: 26,
                        child: RawMaterialButton(
                          padding: EdgeInsets.all(0),
                          elevation: 0,
                          fillColor: Theme.of(context).colorScheme.onSurface,
                          shape: CircleBorder(),
                          onPressed: (){
                            Navigator.pop(context);
                          },

                          child: Container(
                              padding: EdgeInsets.all(7),
                              child:
                              SvgPicture.asset('assets/icons/icon-close-back-black.svg',
                                color:  Theme.of(context).colorScheme.background,)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Divider(
                  color: Theme.of(context).colorScheme.surface,
                  thickness: 1,
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),

          //Time and Date Preview
          Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Column(
                    children: [

                      Text('${ (DateFormat('EEE - d MMM, yyyy').format(tempPickedDate)).toString()}',
                        style:
                        Theme.of(context).textTheme.bodyText1!.apply(color:
                        (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                            ?
                        Theme.of(context).colorScheme.onSurface
                            :
                        Theme.of(context).colorScheme.onError
                        ),
                      ),
                      SizedBox(height: 5,),

                      Text('$selectedOpTime',
                        style:
                        Theme.of(context).textTheme.headline5!.apply(color:
                        Theme.of(context).colorScheme.onBackground
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Divider(
                  color: Theme.of(context).colorScheme.surface,
                  thickness: 1,
                ),

              ],
            ),
          ),

          //Date select
          Expanded(
            child: CupertinoDatePicker(
              //minimumDate: DateTime.now(),
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime dateTime) {
                //

                tempPickedDate = dateTime;
                setState(() {
                  tempPickedDate = dateTime;
                });

                print(dateTime.toString());
              },
            ),
          ),

          //Select Departure Time
          Container(

            child: Column(
              children: [
                Divider(
                  color: Theme.of(context).colorScheme.surface,
                  thickness: 1,
                ),
                SizedBox(height: 10,),

                Container(
                  width: size.width,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //Heading
                      Text('Select Departure Time',
                        style:
                        Theme.of(context).textTheme.bodyText1!.apply(color: (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                            ?
                        Theme.of(context).colorScheme.onSurface
                            :
                        Theme.of(context).colorScheme.onError
                        ),
                      ),
                      SizedBox(height: 12,),

                      Container(
                        height: 200,
                        child: GridView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: opTimes.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: (1 / .22),
                          ),
                          itemBuilder: (BuildContext context, int index){
                            return GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectedOpTime = opTimes[index];
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: (opTimes[index] == selectedOpTime) ? Theme.of(context).colorScheme.primaryVariant :  Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                width: size.width,
                                height: 40,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: Text('${opTimes[index]}',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),

                              ),
                            );
                          },
                        ),
                      )

                    ],


                  ),
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),

          //BUTTON
          Container(
            width: size.width,
            height: 45,
            margin: EdgeInsets.only(
                left: size.width * 0.06,
                right: size.width * 0.06),
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary.withOpacity(0.1)),

                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0))),                    ),
              onPressed: (){
                //completer(SheetResponse(confirmed: true));

                print(tempPickedDate.toString());
                print(selectedOpTime);

                widget.completer(SheetResponse(data: [tempPickedDate, selectedOpTime]));

              },
              child: Text(
                AppLocalizations.of(context)!.set,
                style: Theme.of(context).textTheme.button!.apply(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),
    );

  }
}

class BusLaneBottomSheet extends StatelessWidget {
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //final ScrollController controller = ScrollController();

  final SheetRequest request;
  final Function(SheetResponse) completer;

  BusLaneBottomSheet({
    Key? key,
    required this.request,
    required this.completer,

  }) : super(key: key);

  final ThemeService _themeService = locator<ThemeService>();
  ThemeService get getTheme => _themeService;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        minChildSize: 0.2,
        maxChildSize: 0.9,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            //height: 400,
            width: size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),

            ),
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: [
                //Header
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            SizedBox(
                              height: 26,
                              width: 26,
                            ),
                            Text('${request.title}',
                              style:
                              Theme.of(context).textTheme.headline6!.apply(color: (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                  ?
                              Theme.of(context).colorScheme.onSurface
                                  :
                              Theme.of(context).colorScheme.onError
                              ),
                            ),
                            SizedBox(
                              height: 26,
                              width: 26,
                              child: RawMaterialButton(
                                padding: EdgeInsets.all(0),
                                elevation: 0,
                                fillColor: Theme.of(context).colorScheme.onSurface,
                                shape: CircleBorder(),
                                onPressed: (){
                                  Navigator.pop(context);
                                },

                                child: Container(
                                    padding: EdgeInsets.all(7),
                                    child:
                                    SvgPicture.asset('assets/icons/icon-close-back-black.svg',
                                      color:  Theme.of(context).colorScheme.background,)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Divider(
                        color: Theme.of(context).colorScheme.surface,
                        thickness: 1,
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: request.data.length,
                    physics: BouncingScrollPhysics(),

                    itemBuilder: (_, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.06),
                        //title: Text('${items[index]}'),
                        leading: Text('${request.data[index]}',
                          style: Theme.of(context).textTheme.bodyText1!.apply(color:
                          (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                              ?
                          Theme.of(context).colorScheme.onSecondary
                              :
                          Theme.of(context).colorScheme.onBackground,),
                        ),

                        trailing: (request.description == (request.data[index]).toString())
                            ?
                        Container(height: 20, width: 20,
                          child: SvgPicture.asset( 'assets/icons/tick-mark.svg', color: Theme.of(context).colorScheme.secondary
                          ),
                        )
                            : null,
                        onTap: () {
                          completer(SheetResponse(
                              data: request.data[index]));
                        },
                      );
                    },
                  ),),

                SizedBox(height: 20,),
              ],
            ),
          );
        }
    );

  }
}

class BusTerminalBottomSheet extends StatelessWidget {
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //final ScrollController controller = ScrollController();

  final SheetRequest request;
  final Function(SheetResponse) completer;

  BusTerminalBottomSheet({
    Key? key,
    required this.request,
    required this.completer,

  }) : super(key: key);

  final ThemeService _themeService = locator<ThemeService>();
  ThemeService get getTheme => _themeService;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        minChildSize: 0.2,
        maxChildSize: 0.9,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            //height: 400,
            width: size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),

            ),
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: [
                //Header
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            SizedBox(
                              height: 26,
                              width: 26,
                            ),
                            Text('${request.title}',
                              style:
                              Theme.of(context).textTheme.headline6!.apply(color: (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                  ?
                              Theme.of(context).colorScheme.onSurface
                                  :
                              Theme.of(context).colorScheme.onError
                              ),
                            ),
                            SizedBox(
                              height: 26,
                              width: 26,
                              child: RawMaterialButton(
                                padding: EdgeInsets.all(0),
                                elevation: 0,
                                fillColor: Theme.of(context).colorScheme.onSurface,
                                shape: CircleBorder(),
                                onPressed: (){
                                  Navigator.pop(context);
                                },

                                child: Container(
                                    padding: EdgeInsets.all(7),
                                    child:
                                    SvgPicture.asset('assets/icons/icon-close-back-black.svg',
                                      color:  Theme.of(context).colorScheme.background,)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Divider(
                        color: Theme.of(context).colorScheme.surface,
                        thickness: 1,
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: request.data.length,
                    physics: BouncingScrollPhysics(),

                    itemBuilder: (_, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.06),
                        //title: Text('${items[index]}'),
                        leading: Text('${request.data[index].busTerminalName}',
                          style: Theme.of(context).textTheme.bodyText1!.apply(color:
                          (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                              ?
                          Theme.of(context).colorScheme.onSecondary
                              :
                          Theme.of(context).colorScheme.onBackground,),
                        ),

                        trailing: (request.description == (request.data[index].busTerminalID).toString())
                            ?
                        Container(height: 20, width: 20,
                          child: SvgPicture.asset( 'assets/icons/tick-mark.svg', color: Theme.of(context).colorScheme.secondary
                          ),
                        )
                            : null,
                        onTap: () {
                          completer(SheetResponse(
                              data: request.data[index].busTerminalID));
                        },
                      );
                    },
                  ),),

                SizedBox(height: 20,),
              ],
            ),
          );
        }
    );

  }
}

// ignore: must_be_immutable
class BusDateBottomSheet extends StatelessWidget {
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final SheetRequest request;
  final Function(SheetResponse) completer;

  BusDateBottomSheet({
    Key? key,
    required this.request,
    required this.completer,

  }) : super(key: key);

  final ThemeService _themeService = locator<ThemeService>();

  ThemeService get getTheme => _themeService;

  DateTime tempPickedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
            height: size.height * 0.5,
            width: size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),

            ),
            child: Column(
              children: [
                //Header
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            SizedBox(
                              height: 26,
                              width: 26,
                            ),
                            Text('${request.title}',
                              style:
                              Theme.of(context).textTheme.headline6!.apply(color: (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                  ?
                              Theme.of(context).colorScheme.onSurface
                                  :
                              Theme.of(context).colorScheme.onError
                              ),
                            ),
                            SizedBox(
                              height: 26,
                              width: 26,
                              child: RawMaterialButton(
                                padding: EdgeInsets.all(0),
                                elevation: 0,
                                fillColor: Theme.of(context).colorScheme.onSurface,
                                shape: CircleBorder(),
                                onPressed: (){
                                  Navigator.pop(context);
                                },

                                child: Container(
                                    padding: EdgeInsets.all(7),
                                    child:
                                    SvgPicture.asset('assets/icons/icon-close-back-black.svg',
                                      color:  Theme.of(context).colorScheme.background,)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Divider(
                        color: Theme.of(context).colorScheme.surface,
                        thickness: 1,
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),

                Expanded(
                  child: CupertinoDatePicker(
                    minimumDate: DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime dateTime) {
                      //

                        tempPickedDate = dateTime;

                      print(dateTime.toString());
                    },
                  ),
                ),
                //BUTTON
                Container(
                  width: size.width,
                  height: 45,
                  margin: EdgeInsets.only(
                      left: size.width * 0.06,
                      right: size.width * 0.06),
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary.withOpacity(0.1)),

                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0))),                    ),
                    onPressed: (){
                      //completer(SheetResponse(confirmed: true));

                      print(tempPickedDate.toString());

                      completer(SheetResponse(data: tempPickedDate));

                    },
                    child: Text(
                      AppLocalizations.of(context)!.done,
                      style: Theme.of(context).textTheme.button!.apply(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),

                SizedBox(height: 20,),
              ],
            ),
          );

  }
}

class BusDepartTimeBottomSheet extends StatelessWidget {
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ScrollController controller = ScrollController();

  final SheetRequest request;
  final Function(SheetResponse) completer;

  BusDepartTimeBottomSheet({
    Key? key,
    required this.request,
    required this.completer,

  }) : super(key: key);

  final ThemeService _themeService = locator<ThemeService>();
  ThemeService get getTheme => _themeService;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        minChildSize: 0.2,
        maxChildSize: 0.9,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            //height: 400,
            width: size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),

            ),
            child: Column(
              children: [
                //Header
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            SizedBox(
                              height: 26,
                              width: 26,
                            ),
                            Text('${request.title}',
                              style:
                              Theme.of(context).textTheme.headline6!.apply(color: (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                  ?
                              Theme.of(context).colorScheme.onSurface
                                  :
                              Theme.of(context).colorScheme.onError
                              ),
                            ),
                            SizedBox(
                              height: 26,
                              width: 26,
                              child: RawMaterialButton(
                                padding: EdgeInsets.all(0),
                                elevation: 0,
                                fillColor: Theme.of(context).colorScheme.onSurface,
                                shape: CircleBorder(),
                                onPressed: (){
                                  Navigator.pop(context);
                                },

                                child: Container(
                                    padding: EdgeInsets.all(7),
                                    child:
                                    SvgPicture.asset('assets/icons/icon-close-back-black.svg',
                                      color:  Theme.of(context).colorScheme.background,)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Divider(
                        color: Theme.of(context).colorScheme.surface,
                        thickness: 1,
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    //scrollDirection: Axis.vertical,
                    itemCount: request.data.length,
                    physics: BouncingScrollPhysics(),

                    itemBuilder: (_, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.06),
                        //title: Text('${items[index]}'),
                        leading: Text('${request.data[index]}',
                          style: Theme.of(context).textTheme.bodyText1!.apply(color:
                          (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                              ?
                          Theme.of(context).colorScheme.onSecondary
                              :
                          Theme.of(context).colorScheme.onBackground,),
                        ),

                        trailing: (request.description == request.data[index])
                            ?
                        Container(height: 20, width: 20,
                          child: SvgPicture.asset( 'assets/icons/tick-mark.svg', color: Theme.of(context).colorScheme.secondary
                          ),
                        )
                            : null,
                        onTap: () {
                          completer(SheetResponse(
                              data: request.data[index]));
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: 20,),
              ],
            ),
          );
        }
    );

  }
}

class SafetyBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;


  SafetyBottomSheet({
    Key? key,
    required this.request,
    required this.completer,

  }) : super(key: key);

  final ThemeService _themeService = locator<ThemeService>();
  ThemeService get getTheme => _themeService;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return  DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        minChildSize: 0.9,
        maxChildSize: 0.9,
        builder: (BuildContext context, ScrollController scrollController) {
        return Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),

        ),
        child: Column(
          children: [

            //Header
            Container(
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        SizedBox(
                          height: 26,
                          width: 26,
                        ),
                        Text(AppLocalizations.of(context)!.safetyToolkit,
                          style:
                          Theme.of(context).textTheme.headline6!.apply(color: (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                              ?
                          Theme.of(context).colorScheme.onSurface
                              :
                          Theme.of(context).colorScheme.onError
                          ),
                        ),
                        SizedBox(
                          height: 26,
                          width: 26,
                          child: RawMaterialButton(
                            padding: EdgeInsets.all(0),
                            elevation: 0,
                            fillColor: Theme.of(context).colorScheme.onSurface,
                            shape: CircleBorder(),
                            onPressed: (){
                              Navigator.pop(context);
                            },

                            child: Container(
                                padding: EdgeInsets.all(7),
                                child:
                                SvgPicture.asset('assets/icons/icon-close-back-black.svg',
                                  color:  Theme.of(context).colorScheme.background,)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Divider(
                    color: Theme.of(context).colorScheme.surface,
                    thickness: 1,
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
              padding: EdgeInsets.symmetric(vertical: 10,),
              child: Text(
                AppLocalizations.of(context)!.featuresToHelpSafety,
                style:  Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),

              ),
            ),

            SizedBox(
              height: 15,
            ),

            Container(
              width: size.width,
              //height: 200.0,
              margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
              padding: EdgeInsets.symmetric(vertical: 10,),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Theme.of(context).colorScheme.surface,

              ),
              child: Column(children: [

                //Share ride details
                Container(
                  child: RawMaterialButton(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    onPressed: () async{
                      completer(SheetResponse(data: 'share'));
                    },
                    child: Container(
                      //height: 65,
                      width: size.width,

                      padding: EdgeInsets.symmetric(horizontal: size.width*0.06),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            SvgPicture.asset('assets/icons/share.svg', color: Theme.of(context).colorScheme.onError,),
                            SizedBox(width: 15),

                            Expanded(
                              child: Container(
                                child: Column(
                                  //mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      //width: size.width - 70,
                                      child: Text(
                                        AppLocalizations.of(context)!.shareRideDetails,
                                        style:  Theme.of(context).textTheme.bodyText1,
                                        //maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    SizedBox(
                                      height: 3,
                                    ),

                                    Container(
                                      child: Text(
                                        AppLocalizations.of(context)!.shareLocationAndCarInfo,
                                        style:  Theme.of(context).textTheme.subtitle1,
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                            ),

                            SvgPicture.asset('assets/icons/arrowforward.svg',  color: Theme.of(context).colorScheme.onSurface,),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                //Emergency
                Container(
                  child: RawMaterialButton(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    onPressed: () {
                      completer(SheetResponse(data: 'emergency'));
                    },
                    child: Container(

                      width: size.width,
                      padding: EdgeInsets.symmetric(horizontal: size.width*0.06),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 20,
                                    width: 20,
                                    child: SvgPicture.asset('assets/icons/safetyicon.svg', color: Theme.of(context).colorScheme.error,)),
                                SizedBox(width: 15),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      //width: size.width - 70,
                                      child: Container(
                                        child: Text(
                                          AppLocalizations.of(context)!.emergencyAssist,
                                          style:  Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.error),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: 3,
                                    ),

                                    Container(
                                      child: Text(
                                        AppLocalizations.of(context)!.callLocalAuthorities,
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SvgPicture.asset('assets/icons/arrowforward.svg' , color: Theme.of(context).colorScheme.onSurface,),
                        ],
                      ),
                    ),
                  ),
                ),
              ],),
            )
          ],
        ),
      );
        }
    );
  }
}

class _FloatingBoxBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  const _FloatingBoxBottomSheet({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(

      ),
    );
  }
}