import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'slab_state.dart';

/*
  Demo of drawing.  
  to-do: there is a glitch, that if you are moving when
  you start to draw a path, it does not draw.  The reason
  is that the code expects to draw a path with a TapDown, not a
  PanUpdate.  We need to have PanUpdate do the same thing as
  TapDown when it is the first of a Path.
*/

void main()
{ runApp(const DrawDemo());
}

class DrawDemo extends StatelessWidget
{
  const DrawDemo({super.key});

  @override
  Widget build(BuildContext context) 
  { return MaterialApp
    ( title: 'Draw Demo',
      debugShowCheckedModeBanner: false,
      home: BlocProvider<SlabCubit>
      ( create: (context) => SlabCubit(),
        child: BlocBuilder<SlabCubit,SlabState>
        ( builder: (context, state) 
          { return DrawDemo1();  },
        ),
      ),
    );
  }
}

class DrawDemo1 extends StatelessWidget
{
  DrawDemo1({super.key});

  @override
  Widget build(BuildContext context)
  { SlabCubit slabCubit = BlocProvider.of<SlabCubit>(context);
    SlabState slabState = slabCubit.state;

    return Scaffold
    ( appBar: AppBar( title: Text("Draw Demo") ),
      body: GestureDetector
      ( onTap: ()=>{ },
        onTapDown: (TapDownDetails td ) => slabCubit.doStart(td),
        onPanUpdate: (DragUpdateDetails pdd) { slabCubit.doMove(pdd); },
        onPanEnd: (DragEndDetails de) => slabCubit.doEnd(de),
        child: Container
        ( // color: Colors.amberAccent, // color or decoration, not both
          decoration: BoxDecoration( border: Border.all(color:Colors.red)),
          child: RepaintBoundary // area to extract pixels from later
          ( // key: scribblerKey,
            // isRepaintBoundary: false, // has no such setter, rats!
            child: CustomPaint
            ( size: Size(500,500),
              painter: MyPainter(slabState.strokes)
            ),
          ),
        ),
      ),
    );
  }
}


class MyPainter extends CustomPainter
{
  List<Path> dark;

  MyPainter( this.dark );

  @override
  void paint( Canvas canvas, Size size )
  {
    Paint paint = Paint(  );
    paint.style = PaintingStyle.stroke;
    //paint.strokeWidth = 8; // do as fraction of drawWid
    paint.strokeWidth = 6;
    paint.strokeCap = StrokeCap.round;

    for ( Path pa in dark )
    {
      canvas.drawPath( pa, paint );
    }
  }

  // Always repaint.  The BlocBuilder<SlabCubit ... really has control.
  // And the picture is not that hard anyway.
  @override
  bool shouldRepaint( MyPainter oldDelegate ) { return true; }
}
