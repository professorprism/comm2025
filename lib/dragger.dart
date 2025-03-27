// dragger.dart
// Barrett Koster 2025
// demo of dragging an object.

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class Coords
{ double x, y;
  Coords(this.x,this.y);
}

class DragState
{
  Coords zat; // position of left corner of draggable box
  Coords offset; // while being dragged, position of mouse inside box
  bool dragging; // true iff being dragged

  DragState( this.zat, this.offset, this.dragging );
}
class DragCubit extends Cubit<DragState>
{
  DragCubit( Coords here) : super( DragState(here, Coords(0,0), false ) );

  // mouse goes down here, so establish the offset
  void down( TapDownDetails td ) 
  { Coords here = Coords( td.localPosition.dx, td.localPosition.dy );
    Coords off = Coords( here.x - state.zat.x, here.y - state.zat.y );
    emit( DragState(state.zat, off, true ) );
  }
  // we are dragging, so set the zat from this positoin minus offset
  void drag( DragUpdateDetails td ) 
  { Coords here = Coords( td.localPosition.dx, td.localPosition.dy );
    Coords z = Coords( here.x - state.offset.x, here.y - state.offset.y );
    emit( DragState(z, state.offset, true ) );
  }
  void up( DragEndDetails de )
  {
    emit( DragState(state.zat, Coords(0,0), false ) );
  }
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
      ( create: (context) => DragCubit( Coords(100,100) ),
        child: BlocBuilder<DragCubit,DragState>
        ( builder: (context, state) 
          { return Dragger2();  },
        ),
      ),
    );
  }

}

class Dragger2 extends StatelessWidget
{
  Dragger2({super.key});

  @override
  Widget build( BuildContext context )
  { DragCubit dg = BlocProvider.of<DragCubit>(context);
    return Scaffold
    ( appBar: AppBar(title: Text("dragger")),
      body:  GestureDetector
      ( onTapDown: (TapDownDetails td ) => dg.down(td),
        onPanUpdate: (DragUpdateDetails pdd) { dg.drag(pdd); },
        onPanEnd: (DragEndDetails de) => dg.up(de),
        child: Stack
        ( children:
          [ Tile("W", dg.state.zat ), 
            Tile("G", Coords(300, 150) ),
          ]
        ),
      )
    );
  }
}

class Tile extends StatelessWidget
{ final String face;
  final Coords here;
  Tile( this.face, this.here );

  @override
  Widget build( BuildContext context )
  { /*
    if ( state.dragging )
    { here = Coords( state.zat.x - state.offset.x, 
                      state.zat.y - state.offset.y 
                    ); 
    }
    else
    { here = Coords(state.zat.x, state.zat.y ); }
*/
    return  Tile2(face, here);
  }
      
    

}

class Tile2 extends Positioned
{ final String face;
  final Coords where;
  Tile2(this.face, this.where)
  : super
    ( left: where.x, top: where.y,
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
/*
class DiceState extends State<Tile> 
{
  int face;
  DiceState(this.face);

  Widget build( BuildContext context )
  { return Container
    ( decoration: BoxDecoration
      ( border: Border.all( width:1, ) ),
      height: 100,
      width: 100,
      child: Stack
      ( children: 
        [ ([1,3,5].contains(face)? Dot(40,40): Text("") ), // center
          ([2,3,4,5,6].contains(face)? Dot(10,10): Text("") ), // upper left
          ([2,3,4,5,6].contains(face)? Dot(70,70): Text("") ), // lower right
          ([4,5,6].contains(face)? Dot(10,70): Text("") ), // upper right
          ([4,5,6].contains(face)? Dot(70,10): Text("") ), // lower left
          ([6].contains(face)? Dot(10,40): Text("") ), // center left
          ([6].contains(face)? Dot(70,40): Text("") ), // center right
          //Dot(50, 70),
        ],
      ),
    );
  }
}

class Dot extends Positioned
{
  final double x;
  final double y;

  Dot( this.x, this.y ) 
  : super
  ( left: x, top: y,
    child: Container
    ( height: 10, width: 10,
      decoration: BoxDecoration
      ( color: Colors.black,
        shape: BoxShape.circle,
      ),
    ),
  );
}
*/