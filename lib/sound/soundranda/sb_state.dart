// import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class SoundState
{
  AudioPlayer player;
  AudioRecorder recorder;
  bool isRecording;
  double currentPosition = 0;
  double totalDuration = 0;

  String? filePath;

  String id;

  // use this constructor after the first time, and supply it with
  // the existing player and recorder
  SoundState
  ( { required this.player, 
      required this.recorder,
      required this.isRecording,
      required this.filePath,
      required this.id,
    }
  );

  // use this constructor the first time, creates the audio things
  SoundState.init( this.id ) 
  : player=AudioPlayer(),
    recorder = AudioRecorder(),
    isRecording = false ;

  void dispose()
  { player.dispose();
    recorder.dispose();
  }
}

class SoundCubit extends Cubit<SoundState>
{
  SoundCubit( String id ) :super( SoundState.init(id) );

  Future<void> startRecording() async
  { 
    final bool hasPermish = await state.recorder.hasPermission();
    if (!hasPermish)
    { print("no permission to record");
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    final filename = "sed_${state.id}.m4a";

    // no, do not set it until it works, will be set after
    // recording.  
    // state.filePath = "${dir.path}/$filename";

    String path = "${dir.path}/$filename";
    // path = "assets/x.mp3"; hack

    const config = RecordConfig
    ( encoder: AudioEncoder.aacLc,
      sampleRate: 44100,
      bitRate: 128000,
    );

    await state.recorder.start(config,path: path);
    emit( SoundState
          ( player:state.player, 
            recorder: state.recorder,
            isRecording: true,
            filePath: state.filePath,
            id:state.id,
          ) );
  }

  void stopRecording() async
  {
    final path = await state.recorder.stop();
    print("sound file path = $path");
    emit( SoundState
          ( player:state.player, 
            recorder: state.recorder,
            isRecording: false,
            filePath: path,
            id:state.id,
          ) );
  }

  Future<void> playRecording() async
  {
    if (state.filePath != null )
    {
      await state.player.setFilePath( state.filePath! );
      // we can get the duration here if we want
      state.player.play();
      // we can set the playback start point to something
      // other than zero if we want.
    }
  }

  Future<void> stopPlaying() async
  {
    await state.player.stop();
  }

}