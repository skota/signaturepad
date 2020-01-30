import 'dart:ui';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canvas Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //store offsets
  List<Offset> points = <Offset>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signature App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              //clear all points
              setState(() => points.clear());
            },
          ),
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: () {
              if (points.length > 0) {
                setState(() {
                  //undo method - pop off values from points list
                  points.removeAt(points.length - 1);
                });
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            //print("inside onPanUpdate..");
            setState(() {
              RenderBox box = context.findRenderObject();
              Offset point = box.globalToLocal(details.globalPosition);
              points.add(point);
            });
          },
          onPanEnd: (DragEndDetails details) {
            // points.add(null);
          },
          child: Container(
            margin: EdgeInsets.all(1.0),
            alignment: Alignment.topLeft,
            color: Colors.grey[200],
            child: CustomPaint(
              painter: Signature(points),
            ),
          ),
        ),
      ),
    );
  }
}

class Signature extends CustomPainter {
  final List<Offset> points;

  Signature(this.points);

  @override
  bool shouldRepaint(Signature _) {
    //we always want it to repaint
    return true;
  }

  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6.0;

    //draw a continuous line using points from points
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }
}
