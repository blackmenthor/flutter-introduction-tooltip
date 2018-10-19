import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rect_getter/rect_getter.dart';

enum IntroductionVerticalPosition {
  bottom, top
}

enum IntroductionHorizontalPosition {
  left, right, center
}

class FlutterIntroductionTooltip {
  static const MethodChannel _channel =
      const MethodChannel('flutter_introduction_tooltip');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Widget _invisibleWidget(Rect rect) {
    final clipper = _InvisibleClipper(rect);
    final shadow = const BoxShadow(
        color: Colors.black54, blurRadius: 8.0);
    return CustomPaint(
      child: Container(),
      painter: _InvisiblePainter(
        rect: rect,
        shadow: shadow,
        clipper: clipper,
      ),
    );
  }

  static Widget _topIntroductionWidget(
      Rect rect,
      BuildContext context,
      Color primaryColor,
      String title,
      String subtitle,
      String positiveBtn,
      VoidCallback positiveCallback
      ) {
    Rect invisibleRect = Rect.fromLTRB(rect.left - 8.0, rect.top - (rect.height/2) - 8.0,
        rect.right + 8.0, rect.bottom - (rect.height/2) - 8.0);
    Rect newRect = rect.translate(0.0 , - 1.0);
    while (newRect.bottom > (invisibleRect.top + 24.0)) {
      newRect = newRect.translate(0.0, - 1.0);
    }

    return Positioned(
      bottom: MediaQuery.of(context).size.height - newRect.bottom,
      child: _topDialog(
          context,
          rect,
          primaryColor,
          title,
          subtitle,
          positiveBtn,
          positiveCallback
      ),
    );
  }

  static Widget _bottomIntroductionWidget(
      Rect rect,
      BuildContext context,
      Color primaryColor,
      String title,
      String subtitle,
      String positiveBtn,
      VoidCallback positiveCallback,
    ) {
    return Positioned(
      top: rect.bottom - (rect.height / 2) - 8,
      child: _bottomDialog(
        context,
        rect,
        primaryColor,
        title,
        subtitle,
        positiveBtn,
        positiveCallback,
      ),
    );
  }

  static Widget _topDialog(
      BuildContext context,
      Rect rect
      Color primaryColor,
      String title,
      String subtitle,
      String positiveBtn,
      VoidCallback positiveCallback
      ) {
  Rect invisibleRect = Rect.fromLTRB(rect.left - 8.0, rect.top - (rect.height/2) - 8.0,
  rect.right + 8.0, rect.bottom - (rect.height/2) - 8.0);
  final screenWidth = MediaQuery.of(context).size.width;
  final middleHorizontal = screenWidth/2;
  final dialogWidth = (screenWidth).round();
  final absRight = (dialogWidth/9).round();
  final absLeft = 4;
  final absCenter = (invisibleRect.center.dx/8).round();
  int multiplier = absCenter;
  if (invisibleRect.center.dx.round() > middleHorizontal.round()) {
  multiplier = absRight;
  } else if (invisibleRect.center.dx.round() < middleHorizontal.round()) {
  multiplier = absLeft;
  }
  multiplier = absCenter;
  final double lineLeftPadding = (multiplier*8).toDouble();
  final double circleLeftPadding = ((multiplier-1)*8).toDouble();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                margin: EdgeInsets.only(left: 24.0, right: 24.0),
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                      8.0),

                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme
                          .of(context)
                          .textTheme
                          .display2,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 8.0),
                    ),
                    Text(
                      subtitle,
                      style: Theme
                          .of(context)
                          .textTheme
                          .body1,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 24.0),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                              onPressed: positiveCallback,
                              color: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      18.0)),
                              child: Text(
                                positiveBtn,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .button
                                    .copyWith(
                                    color: Colors.white),
                              )
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: 5.0,
                height: 7.0,
                margin: EdgeInsets.only(left: lineLeftPadding),
                color: Colors.white,
                child: Container(),
              ),
              Container(
                width: 20.0,
                height: 20.0,
                margin: EdgeInsets.only(left: circleLeftPadding),
                decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _bottomDialog(
      BuildContext context,
      Rect rect,
      Color primaryColor,
      String title,
      String subtitle,
      String positiveBtn,
      VoidCallback positiveCallback,
    ) {
    Rect invisibleRect = Rect.fromLTRB(rect.left - 8.0, rect.top - (rect.height/2) - 8.0,
        rect.right + 8.0, rect.bottom - (rect.height/2) - 8.0);
    final screenWidth = MediaQuery.of(context).size.width;
    final middleHorizontal = screenWidth/2;
    final dialogWidth = (screenWidth).round();
    final absRight = (dialogWidth/9).round();
    final absLeft = 4;
    final absCenter = (invisibleRect.center.dx/8).round();
    int multiplier = absCenter;
    if (invisibleRect.center.dx.round() > middleHorizontal.round()) {
      multiplier = absRight;
    } else if (invisibleRect.center.dx.round() < middleHorizontal.round()) {
      multiplier = absLeft;
    }
    multiplier = absCenter;
    final double lineLeftPadding = (multiplier*8).toDouble();
    final double circleLeftPadding = ((multiplier-1)*8).toDouble();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 20.0,
                height: 20.0,
                margin: EdgeInsets.only(left: circleLeftPadding),
                decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle
                ),
              ),
              Container(
                width: 5.0,
                height: 7.0,
                margin: EdgeInsets.only(left: lineLeftPadding),
                color: Colors.white,
                child: Container(),
              ),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                margin: EdgeInsets.only(left: 24.0, right: 24.0),
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                      8.0),

                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme
                          .of(context)
                          .textTheme
                          .display2,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 8.0),
                    ),
                    Text(
                      subtitle,
                      style: Theme
                          .of(context)
                          .textTheme
                          .body1,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 24.0),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                              onPressed: positiveCallback,
                              color: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      18.0)),
                              child: Text(
                                positiveBtn,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .button
                                    .copyWith(
                                    color: Colors.white),
                              )
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  static void showBottomTutorialOnWidget(
      BuildContext context,
      GlobalKey globalKey,
      Color primaryColor,
      VoidCallback positiveCallback,
      String title,
      String subtitle,
      String positiveBtn,
      ) {
    try {
      Rect rect = RectGetter.getRectFromKey(globalKey);
      showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Builder(
                  builder: (BuildContext context) {
                    return Stack(
                      children: <Widget>[
                        _invisibleWidget(rect),
                        // CHILD
                        _bottomIntroductionWidget(
                            rect,
                            context,
                            primaryColor,
                            title,
                            subtitle,
                            positiveBtn,
                            positiveCallback,
                        ),
                      ],
                    );
                  }
              ),
            ),
          );
        },
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations
            .of(context)
            .modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 150),
      );
    } catch (e) {
      print("ERROR $e");
    }
  }

  static void showTopTutorialOnWidget(
      BuildContext context,
      GlobalKey globalKey,
      Color primaryColor,
      VoidCallback positiveCallback,
      String title,
      String subtitle,
      String positiveBtn,
    ) {
    try {
      Rect rect = RectGetter.getRectFromKey(globalKey);
      showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Builder(
                  builder: (BuildContext context) {
                    return Stack(
                      children: <Widget>[
                        _invisibleWidget(rect),
                        // CHILD
                        _topIntroductionWidget(
                            rect,
                            context,
                            primaryColor,
                            title,
                            subtitle,
                            positiveBtn,
                            positiveCallback
                        ),
                      ],
                    );
                  }
              ),
            ),
          );
        },
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations
            .of(context)
            .modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 150),
      );
    } catch (e) {
      print("ERROR $e");
    }
  }
}

class _InvisibleClipper extends CustomClipper<Path> {
  final Rect rect;

  _InvisibleClipper(this.rect);

  @override
  Path getClip(Size size) {
    return Path.combine(PathOperation.difference, Path()..addRect(Offset.zero & size), Path()..addOval(rect));
  }

  @override
  bool shouldReclip(_InvisibleClipper old) => false;
}

class _InvisiblePainter extends CustomPainter {
  _InvisiblePainter({
    @required this.rect,
    @required this.shadow,
    this.clipper,
  });

  final Rect rect;
  final BoxShadow shadow;
  final _InvisibleClipper clipper;

  final double newOffset = 8.0;

  void paint(Canvas canvas, Size size) {
    Rect newRect = Rect.fromLTRB(rect.left - newOffset, rect.top - (rect.height/2) - newOffset,
        rect.right + newOffset, rect.bottom - (rect.height/2) - newOffset);
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawColor(shadow.color, BlendMode.dstATop);
    canvas.drawRect(newRect, Paint()..blendMode = BlendMode.clear);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_InvisiblePainter old) => false;

  @override
  bool shouldRebuildSemantics(_InvisiblePainter oldDelegate) => false;
}
