// slab_state.dart
// Barrett Koster 2024

// SlabState holds the strokes that make up a drawing.
// aPath starts empty, and as soon as you drag it gets
// visible lines added to it.  aPath is also on the 
// list of strokes that you draw.  When you stop
// drawing one stroke/path, the cubit makes a new 
// empty aPath, ready for the next drag.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/rendering.dart';


class SlabState
{
  List<Path> strokes; // list of paths already drawn
  Path aPath; // the path you are in the middle of drawing now

  SlabState( this.strokes, this.aPath )
  {
    // print( "======== |strokes|=${strokes.length}" );
  }
}

class SlabCubit extends Cubit<SlabState>
{
  SlabCubit() : super (  SlabState([], Path()) );

  void doInit(){ emit(SlabState( [], Path() ) ); }
  
  // gets called when you start a stroke.
  // Move the aPath pointer to the coordinates of ds.
  // Assume that a fresh Path already exists.
  //  Add this path to the strokes list, so that we can see it as we make it.
  void doStart( TapDownDetails ds )
  {
    // print("ds");
    state.aPath.moveTo(ds.localPosition.dx, ds.localPosition.dy );
    state.strokes.add(state.aPath);
    emit( SlabState(state.strokes, state.aPath ) );
  }

  // gets called when you move in the middle of a stroke.
  // Add to aPath a lineTo du coordinates.
  // Also do setState here so that we can see it as we draw it.
  void doMove( DragUpdateDetails du )
  {
    // print("du");
    state.aPath.lineTo(du.localPosition.dx, du.localPosition.dy );
    // setState( () {} );
    emit( SlabState(state.strokes, state.aPath ) );
  }
  // gets called when you pick your finger up from stroke.
  // You can add the lineTo if you want, but it's probably not needed.
  // Set aPath to new fresh Path  ready for next stroke.
  void doEnd( DragEndDetails de )
  {
    // print("de");
    // strokes.add(aPath); done at tap down.
    state.aPath = Path();
    // setState( () {} ); done for each move
    emit( SlabState(state.strokes, state.aPath ) );
  }
}