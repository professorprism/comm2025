// life.dart
// Barrett Koster 2025
// demo of implicit animation.

import "dart:math";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class Coords
{ double x, y;
  Coords(this.x,this.y);
}

// DragState keeps track of the position of ONE box as you
// drag it.  When you click down, it does a 3-second
// transition to hte new coordinates (using 
// AnimatedPositioned as the base).
class DragState
{

  List<List<bool>> world;


  DragState( this.world );

  DragState.first() : world = init();

  static List<List<bool>> init()
  { List<List<bool>> grid = [];
    for ( int i=0; i<20; i++ )
    { List<bool> row = [];
      for ( int j=0; j<20; j++ )
      {
        row.add( Random().nextInt(10)>6? true : false );
      }
      grid.add(row);
    }
    return grid;
  }
  
}

class DragCubit extends Cubit<DragState>
{
  DragCubit( ) : super( DragState.first( ) );

  void update( List<List<bool>> c )
  { emit( DragState(c) ); }

}



void main() // 23
{
  runApp(Dragger());
}

class Dragger extends StatelessWidget
{
  const Dragger({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dragger',
      home: BlocProvider<DragCubit>
      ( create: (context) => DragCubit(  ),
        child: BlocBuilder<DragCubit,DragState>
        ( builder: (context, state) 
          { return Dragger2();  },
        ),
      ),
    );
  }

}

void mover( BuildContext context ) async
{
   DragCubit dg = BlocProvider.of<DragCubit>(context);

   await Future.delayed( const Duration(seconds:1) );
  

   // dg.update(c);
}
 
class Dragger2 extends StatelessWidget
{
  Dragger2({super.key});

  

  @override
  Widget build( BuildContext context )
  { DragCubit dg = BlocProvider.of<DragCubit>(context);

  Column theGrid = Column(children:[]);
  for ( List<bool> row in dg.state.world )
  {
     Row r = Row(children:[]);
     for( bool b in row )
     {
        r.children.add( Text(b? " x ":" . ") );
     }
     theGrid.children.add(r);
  } 


    mover(context);
    return Scaffold
    ( appBar: AppBar(title: Text("ani1")),
      body:   Container
        ( width: 500, height:500,
          decoration: BoxDecoration( border: Border.all(width:2) ),
          child: theGrid
        ),
        
    );
  }
}

class Tile extends StatelessWidget
{ final String face;
  final Coords here;
  Tile( this.face, this.here );

  @override
  Widget build( BuildContext context )
  { 
    return  Tile2(face, here);
  }
}

class Tile2 extends AnimatedPositioned
{ final String face;
  final Coords where;
  Tile2(this.face, this.where)
  : super
    ( duration: Duration( seconds: 2 ),
      curve: Curves.ease, // default is linear
      left: where.x, top: where.y,
      child: Container
      ( height: 100, width: 100,
        decoration: BoxDecoration
        ( //color: Colors.black,
          border: Border.all(width:2),
          // shape: BoxShape.circle,
        ),
        child: Text(face),
      ),
    );
}
