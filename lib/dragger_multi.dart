// dragger_multi.dart
// Barrett Koster 2025
// demo of dragging an object.
// This one allows multiple tiles to be dragged

import "dart:math";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

const double TILE_SIZE = 100;

class Coords
{ double x, y;
  Coords(this.x,this.y);
  double dist( Coords c )
  { double xd = c.x - x;
    double yd = c.y - y;
    return sqrt( xd*xd + yd*yd );
  }

  Coords.copy( Coords c ) : x = c.x, y = c.y ; 
}

class DragState
{
  List<Coords> zat; // position of each left corner of boxes
  // Coords zat; // position of left corner of draggable box
  Coords offset; // while being dragged, position of mouse inside box
  //bool dragging; // true iff being dragged
  int dragme = -1; // index in zat of box being dragged, -1 if none

  DragState( this.zat, this.offset, this.dragme );
}
class DragCubit extends Cubit<DragState>
{
  DragCubit( List<Coords> here) : super( DragState(here, Coords(0,0), -1 ) );

  // mouse goes down here, find the tile we are closest to,
  // mark that one (dragme), and note the offset
  void down( TapDownDetails td ) 
  { Coords mouse = Coords( td.localPosition.dx, td.localPosition.dy );
    int dragme = 0;
    double dragmed = 1000000;
    for ( int i=0; i<state.zat.length; i++ )
    { Coords p = Coords.copy(state.zat[i]); // center of square with next line
      p.x += TILE_SIZE/2;  p.y += TILE_SIZE/2;
      double d = mouse.dist(p); // how close is mouse to this tile
      if ( d < dragmed )
      { dragme = i;
        dragmed = d;
      }
    }

    Coords off = Coords( mouse.x - state.zat[dragme].x, 
                         mouse.y - state.zat[dragme].y 
                       );
    emit( DragState(state.zat, off, dragme ) );
  }
  // we are dragging, so set the zat from this positoin minus offset
  void drag( DragUpdateDetails td ) 
  { Coords mouse = Coords( td.localPosition.dx, td.localPosition.dy );
    Coords z = Coords( mouse.x - state.offset.x, mouse.y - state.offset.y );
    state.zat[state.dragme] = z;
    emit( DragState(state.zat, state.offset, state.dragme ) );
  }
  void up( DragEndDetails de )
  {
    emit( DragState(state.zat, Coords(0,0), -1 ) );
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
      ( create: (context) => DragCubit( [Coords(100,100),Coords(200,300),] ),
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

    int i=0;
    List<Tile> kids = [];
    for ( Coords c in dg.state.zat )
    { kids.add( Tile("$i",c) );
      i++;
    }

    return Scaffold
    ( appBar: AppBar(title: Text("dragger")),
      body:  GestureDetector
      ( onTapDown: (TapDownDetails td ) => dg.down(td),
        onPanUpdate: (DragUpdateDetails pdd) { dg.drag(pdd); },
        onPanEnd: (DragEndDetails de) => dg.up(de),
        child: Stack
        ( children: kids ),
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
      ( height: TILE_SIZE, width: TILE_SIZE,
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