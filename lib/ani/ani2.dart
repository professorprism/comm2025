// ani2.dart
// Barrett Koster 2025
// demo of tween animation.

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
        builder: (_, double angle, __ )
        { return Column
          ( children:
            [
              Transform.rotate
              ( angle:angle, 
                child:Text("hi", style: TextStyle(fontSize: 40) ), 
              ),
              Transform.rotate
              ( angle:angle, 
                child: Positioned
                ( left: angle*40, top: 200,
                  child: Text("hi3", style: TextStyle(fontSize: 40) ), 
                ),
              ),
              Positioned
              ( left: angle*30, top: 100, 
                child: Transform.rotate
                ( angle:angle, 
                  child:Text("hi2", style: TextStyle(fontSize: 40) ), 
                )
              ),
              Positioned
              ( left: angle*30, top: 300, 
                child: Text("hi4", style: TextStyle(fontSize: 40) ), 
              ),
              Transform.translate
              ( offset: Offset(  angle*30, 0 ), 
                child: Text("hi5", style: TextStyle(fontSize: 40) ), 
              ),
              Transform.translate
              ( offset: Offset(  angle*30, 0 ), 
                child: Transform.rotate
                ( angle: angle,
                  child:  Text("hi6", style: TextStyle(fontSize: 40) ), 
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
