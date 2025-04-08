// pd.dart
// Barrett Koster
// trying to get the audio_player to work

// > flutter pub add record
// > flutter pub add just_audio

// import 'package:just_audio/just_audio.dart';
// import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sound_state.dart';

void main()
{ runApp(const SayWhat());
}

class SayWhat extends StatelessWidget
{ const SayWhat({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)
  { const title = "sound play from just_audio";
    return MaterialApp
    ( title: title,
      home: 
      /*BlocProvider<SoundCubit>
      ( create: (context) => SoundCubit(),
        child: BlocBuilder<SoundCubit,SoundState>
        ( builder: (context,state)
          { return 
      */
            SayWhat1(title:title)
      /*  },
        )
      ) */
    ); 
  }
}

class SayWhat1 extends StatelessWidget
{ final String title;
  const SayWhat1({super.key, required this.title});

  @override
  Widget build(BuildContext context)
  { // SoundCubit sc = BlocProvider.of<SoundCubit>(context);

    return Scaffold
    ( appBar: AppBar(title: Text(title)),
      body: Column
      ( children: 
        [ /*
          ElevatedButton
          ( onPressed: (){ sc.startRecording(); },
            child: Text("record"),
          ),
          ElevatedButton
          ( onPressed: (){ sc.stopRecording(); },
            child: Text("stop rec"),
          ),
          */
          ElevatedButton
          ( onPressed: ()
            { // sc.playRecording(); 
               AudioPlayer().play(AssetSource('assets/x.mp3'));
               //AudioPlayer().play('assets/x.mp3');
            },
            child: Text("play"),
          ),
          
          ElevatedButton
          ( onPressed: ()
            { // sc.stopPlaying(); 
              AudioPlayer().stop();
            },
            child: Text("stop play"),
          ),
          
        ],
      ),
    );
  }


}
