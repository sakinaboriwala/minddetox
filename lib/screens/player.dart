import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttery_audio/fluttery_audio.dart';

import 'package:mind_detox/models/goal.dart';

class PlayerScreen extends StatefulWidget {
  final Goal goal;
  PlayerScreen(this.goal);
  @override
  State<StatefulWidget> createState() {
    return _PlayerScreenState();
  }
}

class _PlayerScreenState extends State<PlayerScreen> {
  double sliderValue = 0.0;
  bool playing = false;
  double playbackProgress = 0.0;
  IconData icon = Icons.play_arrow;

  @override
  Widget build(BuildContext context) {
    return Audio(
      // audioUrl: widget.goal.audio,
      audioUrl:
          'http://minddetox.app/Dashboard/public/assets/imgs/10%20Minute%20Mind%20Reset.mp3',
      playbackState: PlaybackState.paused,
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Container(
              child: FadeInImage(
                placeholder: AssetImage('images/placeholder.jpg'),
                // image: NetworkImage(widget.goal.featureImage),
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80'),
              ),
              height: 200,
              width: 200,
              decoration: BoxDecoration(border: Border.all()),
            )),
            SizedBox(
              height: 20,
            ),
            Text(
              widget.goal.title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'PlayFair Display'),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AudioComponent(
                  updateMe: [
                    WatchableAudioProperties.audioPlayhead,
                    WatchableAudioProperties.audioSeeking,
                    WatchableAudioProperties.audioLength,
                    WatchableAudioProperties.audioPlayerState
                  ],
                  playerBuilder:
                      (BuildContext context, AudioPlayer player, Widget child) {
                    return IconButton(
                      icon: Icon(
                        Icons.fast_rewind,
                        size: 40,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          sliderValue = sliderValue - 10000;
                          double newValue = sliderValue - 10000;
                          player.seek(
                              new Duration(milliseconds: newValue.toInt()));
                        });
                      },
                    );
                  },
                ),
                SizedBox(
                  width: 25,
                ),
                AudioComponent(
                  updateMe: [
                    WatchableAudioProperties.audioPlayhead,
                    WatchableAudioProperties.audioSeeking,
                    WatchableAudioProperties.audioLength,
                    WatchableAudioProperties.audioPlayerState
                  ],
                  playerBuilder:
                      (BuildContext context, AudioPlayer player, Widget child) {
                    return IconButton(
                      icon: Icon(
                        playing ? Icons.pause : Icons.play_arrow,
                        size: 40,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (player.state == AudioPlayerState.playing) {
                          setState(() {
                            playing = false;
                          });
                          player.pause();
                        } else if (player.state == AudioPlayerState.paused ||
                            player.state == AudioPlayerState.completed) {
                          setState(() {
                            playing = true;
                          });
                          player.play();
                        }
                      },
                    );
                  },
                ),
                SizedBox(
                  width: 25,
                ),
                AudioComponent(
                  updateMe: [
                    WatchableAudioProperties.audioPlayhead,
                    WatchableAudioProperties.audioSeeking,
                    WatchableAudioProperties.audioLength,
                    WatchableAudioProperties.audioPlayerState
                  ],
                  playerBuilder:
                      (BuildContext context, AudioPlayer player, Widget child) {
                    return IconButton(
                      icon: Icon(
                        Icons.fast_forward,
                        size: 40,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          sliderValue = sliderValue + 10000;
                          double newValue = sliderValue + 10000;
                          player.seek(
                              new Duration(milliseconds: newValue.toInt()));
                        });
                      },
                    );
                  },
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 40, right: 40),
              child: audioSlider(),
            ),
          ],
        ),
      ),
    );
  }

  Widget audioSlider() {
    return AudioComponent(
      updateMe: [
        WatchableAudioProperties.audioPlayhead,
        WatchableAudioProperties.audioSeeking,
        WatchableAudioProperties.audioLength,
        WatchableAudioProperties.audioPlayerState
      ],
      playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
        print('--------LENGTH---------');
        print(player.audioLength.toString());
        // print("AUDIO LENGTH");
        // print(player.audioLength.inMilliseconds.toDouble());
        if (player.audioLength != null && player.position != null) {
          playbackProgress = player.position.inMilliseconds /
              player.audioLength.inMilliseconds;
          // print("PLAYBACK PROGRESS");
          // print(playbackProgress);
        }
        return Column(children: [
          CupertinoSlider(
            onChangeEnd: (value) {
              setState(() {
                sliderValue = value;
                double duration =
                    value * player.audioLength.inMilliseconds.toDouble();
                print("-------VALUE-------");
                print(value);
                player.seek(new Duration(milliseconds: value.toInt()));
              });
            },
            min: 0.0,
            max: player.audioLength != null
                ? player.audioLength.inMilliseconds.toDouble() == -1
                    ? 1
                    : player.audioLength.inMilliseconds.toDouble()
                : 1,
            activeColor: Colors.white,
            value: sliderValue,
            onChanged: (value) {
              print(value);
              setState(() {
                sliderValue = value;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.15),
                child: Text(
                  player.position != null
                      ? player.position.toString().substring(2, 7)
                      : '00:00',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.15),
                child: Text(
                    player.audioLength != null
                        ? player.audioLength.toString().substring(2, 7)
                        : '00:00',
                    style: TextStyle(color: Colors.white)),
              )
            ],
          )
        ]);
      },
    );
  }
}
