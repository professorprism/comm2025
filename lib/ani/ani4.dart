// ani3.dart
// Barrett Koster 2025

// This demo does not work. (yet?)

// AnimationController

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ACState
{
  AnimationController ac;

  ACState( this.ac );
}
class ACCubit extends Cubit<ACState>

{
  ACCubit( TickerProvider tp ): super
  ( ACState
    ( AnimationController
      ( duration: Duration( seconds: 10 ),
        vsync: tp,
      )..repeat() 
    ) 
  );
}

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
      home: 
      //BlocProvider<ACCubit>
      //( create: (context) => ACCubit( TickerProvider() ),
      //  child: BlocBuilder<ACCubit, ACState>
      //  ( builder: (context,state) => 
          Dragger2(),
      //  )
      //),
    );
  }
}

class Dragger2 extends StatelessWidget
{
  Dragger2({super.key});

  @override
  Widget build( BuildContext context )
  { ACCubit accubit = BlocProvider.of<ACCubit>(context);
    return Scaffold
    ( appBar: AppBar(title: Text("ani2")),
      body:  TweenAnimationBuilder
      ( duration: Duration( seconds:5),
        tween: Tween<double>(begin:0, end:6.28 ), // 2 pi
        builder: (a, double angle, b )
        { return Column
          ( children:
            [ RotationTransition
              ( alignment: Alignment.center,
                turns: accubit.state.ac,
                child: Text("hi", style: TextStyle(fontSize: 40) ), 
              ),
            ],
          );
        },
      ),
    );
  }
}
