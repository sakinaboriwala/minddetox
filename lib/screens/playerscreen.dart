// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
// import 'dart:async';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:audioplayers/audio_cache.dart';

// import 'package:mind_detox/models/goal.dart';

// enum PlayerState { stopped, playing, paused }

// class PlayerScreen extends StatefulWidget {
//   final Goal goal;
//   PlayerScreen(this.goal);
//   @override
//   State<StatefulWidget> createState() {
//     return _PlayerScreenState();
//   }
// }

// class _PlayerScreenState extends State<PlayerScreen> {
//   PlayerMode mode;
//   bool _isLoading = true;
//   bool playing = false;
//   AudioPlayer _audioPlayer = AudioPlayer();
//   AudioPlayerState _audioPlayerState;
//   Duration _duration;
//   Duration _position;
//   PlayerState _playerState = PlayerState.stopped;
//   StreamSubscription _durationSubscription;
//   StreamSubscription _positionSubscription;
//   StreamSubscription _playerCompleteSubscription;
//   StreamSubscription _playerErrorSubscription;
//   StreamSubscription _playerStateSubscription;
//   get _isPlaying => _playerState == PlayerState.playing;
//   get _isPaused => _playerState == PlayerState.paused;
//   get _durationText => _duration?.toString()?.split('.')?.first ?? '';
//   get _positionText => _position?.toString()?.split('.')?.first ?? '';
//   @override
//   void initState() {
//     _initAudioPlayer();
//     Future.delayed(Duration(seconds: 10), () {
//       setState(() {
//         _isLoading = false;
//       });
//     });
//     super.initState();
//   }

//   Future<int> _play() async {
//     final playPosition = (_position != null &&
//             _duration != null &&
//             _position.inMilliseconds > 0 &&
//             _position.inMilliseconds < _duration.inMilliseconds)
//         ? _position
//         : null;
//     final result = await _audioPlayer.play('https://drive.google.com/file/d/1hOD_AZEJilcrB5ZVoZa_nyx72_cwN0Gp/view',);
//     if (result == 1) setState(() => _playerState = PlayerState.playing);
//     return result;
//   }

//   void _onComplete() {
//     setState(() => _playerState = PlayerState.stopped);
//   }

//   @override
//   void dispose() {
//     _audioPlayer.stop();
//     _durationSubscription?.cancel();
//     _positionSubscription?.cancel();
//     _playerCompleteSubscription?.cancel();
//     _playerErrorSubscription?.cancel();
//     _playerStateSubscription?.cancel();
//     super.dispose();
//   }

//   void _initAudioPlayer() {
//     _audioPlayer = AudioPlayer(mode: mode);

//     _durationSubscription =
//         _audioPlayer.onDurationChanged.listen((duration) => setState(() {
//               _duration = duration;
//             }));

//     _positionSubscription =
//         _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
//               _position = p;
//             }));

//     _playerCompleteSubscription =
//         _audioPlayer.onPlayerCompletion.listen((event) {
//       _onComplete();
//       setState(() {
//         _position = _duration;
//       });
//     });

//     _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
//       print('audioPlayer error : $msg');
//       setState(() {
//         _playerState = PlayerState.stopped;
//         _duration = Duration(seconds: 0);
//         _position = Duration(seconds: 0);
//       });
//     });

//     _audioPlayer.onPlayerStateChanged.listen((state) {
//       if (!mounted) return;
//       setState(() {
//         _audioPlayerState = state;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Center(
//               child: Container(
//             child: _isLoading
//                 ? CupertinoActivityIndicator()
//                 : Image.network(widget.goal.featureImage),
//             height: 200,
//             width: 200,
//             decoration: BoxDecoration(border: Border.all()),
//           )),
//           SizedBox(
//             height: 20,
//           ),
//           Text(
//             widget.goal.title,
//             style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontFamily: 'PlayFair Display'),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               IconButton(
//                 icon: Icon(
//                   Icons.fast_rewind,
//                   size: 40,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {},
//               ),
//               SizedBox(
//                 width: 25,
//               ),
//               !_isLoading
//                   ? IconButton(
//                       icon: Icon(
//                         playing ? Icons.pause : Icons.play_arrow,
//                         size: 40,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         _play();
//                       },
//                     )
//                   : Container(
//                       child: CupertinoActivityIndicator(),
//                     ),
//               SizedBox(
//                 width: 25,
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.fast_forward,
//                   size: 40,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {},
//               )
//             ],
//           ),
//           Container(
//             padding: EdgeInsets.only(left: 40, right: 40),
//             child: audioSlider(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget audioSlider() {
//     return Column(children: [
//       CupertinoSlider(
//         onChangeEnd: (value) {},
//         min: 0.0,
//         max: 1,
//         activeColor: Colors.white,
//         value: 0,
//         onChanged: (value) {},
//       ),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Padding(
//             padding:
//                 EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15),
//             child: Text(
//               '00:00',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(
//                 right: MediaQuery.of(context).size.width * 0.15),
//             child: Text('00:00', style: TextStyle(color: Colors.white)),
//           )
//         ],
//       )
//     ]);
//   }
// }
