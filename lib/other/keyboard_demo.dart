// Barrett Koster 2024 
// keyboard demo
// does not seem to be quite working ....

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bb.dart';

TextStyle ts25 = TextStyle( fontSize: 25 );

class KeyboardState
{
  bool showit = false;
  KeyboardState( this.showit );
}
class KeyboardCubit extends Cubit<KeyboardState>
{
  KeyboardCubit() : super( KeyboardState(false) );
  set( bool s ) { emit( KeyboardState(s) ); }
}

class StringCubit extends Cubit<String>
{  StringCubit() : super( "" );
   say(String s) { emit(s); }
}

void main() async
{ runApp(const KD());

}

class KD extends StatelessWidget 
{ const KD({super.key});
  final title = "Keyboard Demo";

  @override
  Widget build(BuildContext context) 
  { return  MaterialApp
    ( 
      title: title,
      home: Scaffold
      ( appBar: AppBar( title: BB(title) ),
        body: BlocProvider<KeyboardCubit>
        ( create: (context) => KeyboardCubit(),
          child: BlocBuilder<KeyboardCubit,KeyboardState>
          ( builder: (context,state) => BlocProvider<StringCubit>
            ( create: (context) => StringCubit(),
              child: BlocBuilder<StringCubit,String>
              ( builder: (context, state) => KD1()
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KD1 extends StatelessWidget 
{ KD1({super.key});
  final TextEditingController tec = TextEditingController();

  @override
  Widget build(BuildContext context)
  { KeyboardCubit kc = BlocProvider.of<KeyboardCubit>(context);
    StringCubit scub = BlocProvider.of<StringCubit>(context);

    return Center
    ( child: Column
      ( children:
        [ BB(scub.state),
          SizedBox
          ( height: 50, width: 200,
            child: Focus
            ( onFocusChange:(hasFocus) { kc.set( true); },
              child: TextField( controller:tec, style:ts25, ), 
            ),
          ),
          ElevatedButton
          ( onPressed: (){ scub.say( tec.text ); },
            child: Text("accept"),
          ),
          ElevatedButton
          ( onPressed: (){ kc.set( !kc.state.showit );  },
            child: Text("keyboard"),
          ),
          kc.state.showit ? KeyBoard( tec ) : Text("xxx"),
        ],
      )
    );
  }
}

class KeyBoard extends StatelessWidget
{
  TextEditingController tec;
  KeyBoard( this.tec );

  Widget build( BuildContext context )
  {
    return Column
    ( children:
      [ 
        Row
        ( children: 
          [ ky("Q"),ky("W"),ky("E"),ky("R"),ky("T"),
            ky("Y"),ky("U"),ky("I"),ky("O"),ky("P"),
          ],
        ),
        Row
        ( children: 
          [ ky("A"),ky("S"),ky("D"),ky("F"),ky("G"),
            ky("H"),ky("J"),ky("K"),ky("L"),
          ],
        ),
        Row
        ( children: 
          [ ky("Z"),ky("X"),ky("C"),ky("V"),ky("B"),
            ky("N"),ky("M"),
          ],
        ),
      ],
    );
  }

  Widget ky( String letter )
  { return Container
    ( decoration: BoxDecoration(border:Border.all(width:2)),
      width:50, height:40,
      child: ElevatedButton
      ( onPressed: (){ tec.text = tec.text + letter ; },
        child: Text( letter, style: TextStyle(fontSize: 16) ),
      ),
    );
  }
}
