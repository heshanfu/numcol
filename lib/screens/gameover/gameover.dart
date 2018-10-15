import 'package:flutter/material.dart' hide Color;
import 'package:numcolengine/numcolengine.dart';

import '../../widgets/menu_button.dart';
import '../../styles.dart';
import '../../core/index.dart';
import '../../routes.dart';

class GameoverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  padding: const EdgeInsets.only(
                    bottom: 60.0
                  ),
                  child: Text(
                    'Game Over'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 42.0,
                      color: ScreenColors.black,
                      fontFamily: Fonts.poiretone,
                    ),
                  ),
                ),
              ),
              MenuButton(
                color: Color.green,
                text: Translations.of(context).text('play'),
                onPressed: () => Navigator.pushNamed(context, Routes.countdown),
              ),
            ],
          ),
        ),
      ),
    );
  }
}