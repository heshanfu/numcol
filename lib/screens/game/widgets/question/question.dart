// Copyright (C) 2018 Alberto Varela Sánchez <alberto@berriart.com>
// Use of this source code is governed by the version 3 of the
// GNU General Public License that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../../../engine/index.dart';
import '../../../../view/index.dart';
import '../../../../i18n/index.dart';

typedef void DismissAnimationCallback();

const gameColorWords = {
  Color.blue: 'blue',
  Color.red: 'red',
  Color.green: 'green',
  Color.yellow: 'yellow',
};

const gameNumberWords = {
  Number.one: 'one',
  Number.two: 'two',
  Number.three: 'three',
  Number.four: 'four',
  Number.five: 'five',
  Number.six: 'six',
  Number.seven: 'seven',
  Number.eight: 'eight',
  Number.nine: 'nine',
};

class QuestionWidget extends StatefulWidget {
  QuestionWidget({Key key, @required this.question, @required this.isColorOk, @required this.isNumberOk})
    : super(key: key);

  final ValueNotifier<Answer> question;
  final ValueNotifier<bool> isColorOk;
  final ValueNotifier<bool> isNumberOk;

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> with TickerProviderStateMixin {
  final Tween colorTween = ColorTween(begin: ScreenColors.black, end: ScreenColors.darkRed);
  AnimationController _colorAnimationController;
  AnimationController _numberAnimationController;
  Animation _colorAnimation;
  Animation _numberAnimation;

  AnimationController _createAnimationController() {
    return new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400)
    );
  }

  Animation _createAnimation(AnimationController controller, DismissAnimationCallback dismissAnimationCallbak) {
    return colorTween.animate(controller)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.stop();
        dismissAnimationCallbak();
      }
    })..addListener(() {
      setState((){});
    });
  }

  void _blinkColorWhenError() {
    if (!widget.isColorOk.value) {
      _colorAnimationController.forward();
    }
  }

  void _blinkNumberWhenError() {
    if (!widget.isNumberOk.value) {
      _numberAnimationController.forward();
    }
  }

  void _setState() {
    setState(() => null);
  }

  @override
  void initState() {
    super.initState();
    _colorAnimationController = _createAnimationController();
    _numberAnimationController = _createAnimationController();
    _colorAnimation = _createAnimation(_colorAnimationController, () => widget.isColorOk.value = true);
    _numberAnimation = _createAnimation(_numberAnimationController, () => widget.isNumberOk.value = true);
    widget.isColorOk.addListener(_blinkColorWhenError);
    widget.isNumberOk.addListener(_blinkNumberWhenError);
    widget.question.addListener(_setState);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50.0, bottom: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            Translations.of(context).text(gameNumberWords[widget.question.value.number]).toUpperCase(),
            style: TextStyle(
              fontFamily: Fonts.poiretone,
              fontSize: 36.0,
              color: _numberAnimation.value,
            ),
          ),
          Text(' '),
          Text(
            Translations.of(context).text(gameColorWords[widget.question.value.color]).toUpperCase(),
            style: TextStyle(
              fontFamily: Fonts.poiretone,
              fontSize: 36.0,
              color: _colorAnimation.value,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.question.removeListener(_setState);
    widget.isColorOk.removeListener(_blinkColorWhenError);
    widget.isNumberOk.removeListener(_blinkNumberWhenError);
    _colorAnimationController.dispose();
    _numberAnimationController.dispose();
    super.dispose();
  }
}