import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum IntroductionVerticalPosition {
  bottom, top
}

enum IntroductionHorizontalPosition {
  left, right, center
}

enum LineHorizontalPosition {
  left, right, center
}

Rect getInvisibleRect(Rect rect) {
  return Rect.fromLTRB(rect.left, rect.top - 24,
      rect.right, rect.bottom - 24);
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
      VoidCallback positiveCallback,
      bool showLine,
      double lineHeight,
      {
        LineHorizontalPosition lineHorizontalPosition,
        Widget childBoxWidget,
      }
      ) {
    Rect invisibleRect = getInvisibleRect(rect);
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
          positiveCallback,
          showLine,
          lineHeight,
          lineHorizontalPosition: lineHorizontalPosition,
          childBoxWidget: childBoxWidget,
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
      bool showLine,
      double lineHeight,
      {
        LineHorizontalPosition lineHorizontalPosition,
        Widget childBoxWidget,
      }
    ) {
    return Positioned(
      top: rect.bottom - 24.0,
      child: _bottomDialog(
        context,
        rect,
        primaryColor,
        title,
        subtitle,
        positiveBtn,
        positiveCallback,
        showLine,
        lineHeight,
        lineHorizontalPosition: lineHorizontalPosition,
        childBoxWidget: childBoxWidget,
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
      VoidCallback positiveCallback,
      bool showLine,
      double lineHeight,
      {
        LineHorizontalPosition lineHorizontalPosition,
        Widget childBoxWidget,
      }
      ) {
  Rect invisibleRect = getInvisibleRect(rect);
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
  if (lineHorizontalPosition != null) {
    switch(lineHorizontalPosition) {
      case LineHorizontalPosition.center:
        multiplier = absCenter;
        break;
      case LineHorizontalPosition.left:
        multiplier = absLeft;
        break;
      case LineHorizontalPosition.right:
        multiplier = absRight;
        break;
      default:
        break;
    }
  }
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
              childBoxWidget ?? Container(
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
                height: lineHeight,
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
      bool showLine,
      double lineHeight,
      {
        LineHorizontalPosition lineHorizontalPosition,
        Widget childBoxWidget,
      }
    ) {
    Rect invisibleRect = getInvisibleRect(rect);
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
    if (lineHorizontalPosition != null) {
      switch (lineHorizontalPosition) {
        case LineHorizontalPosition.center:
          multiplier = absCenter;
          break;
        case LineHorizontalPosition.left:
          multiplier = absLeft;
          break;
        case LineHorizontalPosition.right:
          multiplier = absRight;
          break;
        default:
          break;
      }
    }
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
              showLine ? Container(
                width: 20.0,
                height: 20.0,
                margin: EdgeInsets.only(left: circleLeftPadding),
                decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle
                ),
              ) : Container(),
              showLine ? Container(
                width: 5.0,
                height: lineHeight,
                margin: EdgeInsets.only(left: lineLeftPadding),
                color: Colors.white,
                child: Container(),
              ): Container(),
              childBoxWidget ?? Container(
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
      {
        LineHorizontalPosition lineHorizontalPosition,
        Widget childBoxWidget,
        bool showLine = true,
        double lineHeight = 7.0,
      }
      ) {
    try {
      final box = globalKey.currentContext.findRenderObject() as RenderBox;
      Rect rect =  box.localToGlobal(Offset.zero) & box.size;
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
                            showLine,
                            lineHeight,
                            lineHorizontalPosition: lineHorizontalPosition,
                            childBoxWidget: childBoxWidget,
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
      {
        LineHorizontalPosition lineHorizontalPosition,
        Widget childBoxWidget,
        bool showLine = true,
        double lineHeight = 7.0,
      }
    ) {
    try {
      final box = globalKey.currentContext.findRenderObject() as RenderBox;
      Rect rect =  box.localToGlobal(Offset.zero) & box.size;
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
                            positiveCallback,
                            showLine,
                            lineHeight,
                            lineHorizontalPosition: lineHorizontalPosition,
                            childBoxWidget: childBoxWidget,
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

  void paint(Canvas canvas, Size size) {
    Rect newRect = getInvisibleRect(rect);
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
