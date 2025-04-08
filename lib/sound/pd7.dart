
// pd7.dart
// from StackOverflow lepsch 2022
// Barrett Koster hacking into ... ?


import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AState
{
  AudioPlayer thep;

  AState( this.thep );


}
class ACubit extends Cubit<AState>
{
  ACubit() : super( AState( AudioPlayer() ) );

  void play()
  {
    state.thep.play(AssetSource('x.mp3'));
  }

  void stop()
  {
    state.thep.stop();
  }

}

void main()
{ runApp(const SoundDemo());
}

class SoundDemo extends StatelessWidget
{
  const SoundDemo({super.key});

  @override
  Widget build(BuildContext context)
  { return MaterialApp
    ( title: 'sound demo 7',
      home: SoundDemo2(), // MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SoundDemo2 extends StatelessWidget
{
  @override
  Widget build( BuildContext context )
  { return BlocProvider<ACubit>
    ( create: (context) => ACubit(),
      child: BlocBuilder<ACubit,AState>
      ( builder: (context,state) => SoundDemo3(),
      ),
    );
  }
}

class SoundDemo3 extends StatelessWidget
{
  @override
  Widget build( BuildContext context )
  { 
    ACubit ac = BlocProvider.of<ACubit>(context);

    return Scaffold
    ( appBar: AppBar( title: Text("sound demo 7") ),
      body: Column
      ( children:
        [ ElevatedButton
          ( onPressed: (){ ac.play(); },
            child: Text("play x"),
          ),
          ElevatedButton
          ( onPressed: (){ ac.stop(); },
            child: Text("stop x"),
          ),
        ],
      ),
    );
  }
}
