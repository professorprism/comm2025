// ani3.dart
// Barrett Koster 2025
// still doing implicit animation

import "package:flutter/material.dart";

void main()
{
  runApp(Dragger());
}

class Dragger extends StatelessWidget
{
  const Dragger({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp
    ( title: 'Dragger',
      home: Dragger2(),
    );
  }
}

class Dragger2 extends StatelessWidget
{
  Dragger2({super.key});

  @override
  Widget build( BuildContext context )
  { //DragCubit dg = BlocProvider.of<DragCubit>(context);
    return Scaffold
    ( appBar: AppBar(title: Text("ani2")),
      body:  TweenAnimationBuilder
      ( duration: Duration( seconds:5),
        tween: Tween<double>(begin:0, end:6.28 ), // 2 pi
        builder: (a, double angle, b )
        { return Transform.rotate
          ( angle:angle, 
            child: Column
            ( children:
              [ Text("hi", style: TextStyle(fontSize: 40) ), 
                Text("there", style: TextStyle(fontSize: 40) ),
              ],
            ),
          );
        },
      ),
    );
  }
}
