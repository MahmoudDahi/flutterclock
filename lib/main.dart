import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Clock',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.deepOrange),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clock'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          alignment: Alignment.center,
          color: const Color(0xFF2D2f43),
          child: const ClockView(),
        ),
      ),
    );
  }
}

class ClockView extends StatefulWidget {
  const ClockView({
    Key? key,
  }) : super(key: key);

  @override
  State<ClockView> createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Transform.rotate(
        angle: -pi / 2,
        child: CustomPaint(
          painter: ClockPainter(DateTime.now()),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime dateTime;

  ClockPainter(this.dateTime);
  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var raduis = min(centerX, centerY);

    Paint fillCircle = Paint()..color = const Color(0xff444974);

    Paint storkeCircle = Paint()
      ..color = Colors.white
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;

    Paint dotCircle = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Paint secLine = Paint()
      ..color = Colors.orange
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Paint minLine = Paint()
      ..shader = const RadialGradient(colors: [
        Colors.lightBlue,
        Colors.purple,
      ]).createShader(Rect.fromCircle(
        center: center,
        radius: raduis,
      ))
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Paint hourLine = Paint()
      ..shader = const RadialGradient(colors: [
        Colors.deepOrange,
        Colors.pink,
      ]).createShader(Rect.fromCircle(
        center: center,
        radius: raduis,
      ))
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, raduis - 40, fillCircle);
    canvas.drawCircle(center, raduis - 40, storkeCircle);

    var outerLine = raduis-52;
    var innerLine = raduis - 72;
    var innerShortLine = raduis - 60;

    Paint dashBrash = Paint()
      ..strokeWidth = 2
      ..color = Colors.white;

    for (int i = 0; i < 360; i += 30) {
      var x1 = centerX + outerLine * cos(i * pi / 180);
      var y1 = centerX + outerLine * sin(i * pi / 180);

      var x2 = centerX + innerLine * cos(i * pi / 180);
      var y2 = centerX + innerLine * sin(i * pi / 180);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrash);
    }

    for (int i = 0; i < 360; i += 6) {
      var x1 = centerX + innerLine * cos(i * pi / 180);
      var y1 = centerX + innerLine * sin(i * pi / 180);

      var x2 = centerX + innerShortLine * cos(i * pi / 180);
      var y2 = centerX + innerShortLine * sin(i * pi / 180);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrash);
    }

    var hourX = centerX +
        50 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourY = centerX +
        50 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourX, hourY), hourLine);

    var minX = centerX + 60 * cos(dateTime.minute * 6 * pi / 180);
    var minY = centerX + 60 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minX, minY), minLine);

    var secX = centerX + 80 * cos(dateTime.second * 6 * pi / 180);
    var secY = centerX + 80 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secX, secY), secLine);

    canvas.drawCircle(center, 12, dotCircle);

    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
