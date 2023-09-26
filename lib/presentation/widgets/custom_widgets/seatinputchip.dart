



import 'package:flutter/material.dart';
import '../../../../app/app.locator.dart';
import '../../../../data/data_sources/local/sharedpreference.dart';

class SeatInputChip extends StatefulWidget {
  const SeatInputChip({Key? key}) : super(key: key);

  @override
  _SeatInputChipState createState() => _SeatInputChipState();
}

class _SeatInputChipState extends State<SeatInputChip> {
  final SharedPrefManager _sharedPrefManager = locator<SharedPrefManager>();
  SharedPrefManager get getSharedPrefManager => _sharedPrefManager;

  int _selectedIndex = 0;

  List<String> _options = [
    '1',
    '2',
    '3'
  ];

  Widget _buildChips(BuildContext context) {
    List<Widget> chips = [];

    for (int i = 0; i < _options.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: _selectedIndex == i,
        label: Text(_options[i], style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground)),
        elevation: 0,
        pressElevation: 0,
        padding: EdgeInsets.all(9),
        backgroundColor:  Theme.of(context).colorScheme.surface,
        selectedColor: Theme.of(context).colorScheme.secondaryVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedIndex = i;

            }
          });
        },
      );

      chips.add(Padding(padding: EdgeInsets.only(left: 5), child: choiceChip));
    }

    return Row(
      // This next line does the trick.
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: chips,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            Container(
              height: 60,
              child: _buildChips(context),
            ),
          ],
        ));
  }
}