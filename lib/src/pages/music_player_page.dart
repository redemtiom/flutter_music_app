import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/src/helpers/helpers.dart';
import 'package:music_player/src/models/audioplayer_model.dart';
import 'package:music_player/src/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class MusicPlayerPage extends StatelessWidget {
  const MusicPlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          Column(
            children: const [
              CustomAppBar(),
              ImageDiscDuration(),
              TitlePlay(),
              Expanded(
                child: Lyrics(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: screenSize.height * 0.8,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60.0)),
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.center,
            colors: [Color(0xff33333E), Color(0xff201E28)]),
      ),
    );
  }
}

class Lyrics extends StatelessWidget {
  const Lyrics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lyrics = getLyrics();

    return Container(
      child: ListWheelScrollView(
        physics: const BouncingScrollPhysics(),
        itemExtent: 42,
        diameterRatio: 1.5,
        children: lyrics
            .map((linea) => Text(
                  linea,
                  style: TextStyle(
                      fontSize: 20.0, color: Colors.white.withOpacity(0.6)),
                ))
            .toList(),
      ),
    );
  }
}

class TitlePlay extends StatefulWidget {
  const TitlePlay({
    Key? key,
  }) : super(key: key);

  @override
  State<TitlePlay> createState() => _TitlePlayState();
}

class _TitlePlayState extends State<TitlePlay>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool firstTime = true;
  late AnimationController playAnimation;
  final assetAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    playAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    playAnimation.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void open() {
    final audioPlayerModel =
        Provider.of<AudioPlayerModel>(context, listen: false);
    assetAudioPlayer.open(
      Audio('assets/Breaking-Benjamin-Far-Away.mp3'),
      autoStart: true,
      showNotification: true,
    );

    assetAudioPlayer.currentPosition.listen((duration) {
      audioPlayerModel.current = duration;
    });

    assetAudioPlayer.current.listen((Playing? event) {
      audioPlayerModel.songDuration =
          event?.audio.duration ?? const Duration(milliseconds: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      margin: const EdgeInsets.only(top: 40.0),
      child: Row(
        children: [
          Column(
            children: [
              Text('Far Away',
                  style: TextStyle(
                      fontSize: 30.0, color: Colors.white.withOpacity(0.8))),
              Text('-Breaking Benjamin-',
                  style: TextStyle(
                      fontSize: 15.0, color: Colors.white.withOpacity(0.5))),
            ],
          ),
          const Spacer(),
          FloatingActionButton(
            onPressed: () {
              final audioPlayerModel =
                  Provider.of<AudioPlayerModel>(context, listen: false);

              if (isPlaying) {
                playAnimation.reverse();
                isPlaying = false;
                audioPlayerModel.controller.stop();
              } else {
                playAnimation.forward();
                isPlaying = true;
                audioPlayerModel.controller.repeat();
              }

              if (firstTime) {
                open();
                firstTime = false;
              } else {
                assetAudioPlayer.playOrPause();
              }
            },
            backgroundColor: const Color(0xffF8CB51),
            elevation: 0,
            highlightElevation: 0,
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: playAnimation,
            ),
          )
        ],
      ),
    );
  }
}

class ImageDiscDuration extends StatelessWidget {
  const ImageDiscDuration({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      margin: const EdgeInsets.only(top: 70.0),
      child: Row(
        children: const [
          ImageDisc(),
          SizedBox(width: 35.0),
          ProgressBar(),
          SizedBox(width: 20.0),
        ],
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(color: Colors.white.withOpacity(0.4));
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    final percent = audioPlayerModel.percent;

    return Container(
      child: Column(
        children: [
          Text('${audioPlayerModel.songTotalDuration }', style: style),
          const SizedBox(
            height: 10.0,
          ),
          Stack(
            children: [
              Container(
                width: 3.0,
                height: 230.0,
                color: Colors.white.withOpacity(0.1),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 3.0,
                  height: 230.0 * percent,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text('${audioPlayerModel.currentSecond }', style: style),
        ],
      ),
    );
  }
}

class ImageDisc extends StatelessWidget {
  const ImageDisc({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);

    return Container(
      padding: const EdgeInsets.all(20.0),
      width: 250.0,
      height: 250.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200.0),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            colors: [Color(0xff484750), Color(0xff1E1C24)],
          )),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinPerfect(
                duration: Duration(seconds: 10),
                infinite: true,
                manualTrigger: true,
                controller: (animationContoller) =>
                    audioPlayerModel.controller = animationContoller,
                child: Image(image: AssetImage('assets/aurora.jpg'))),
            Container(
              width: 25.0,
              height: 25.0,
              decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(100.0)),
            ),
            Container(
              width: 18.0,
              height: 18.0,
              decoration: BoxDecoration(
                  color: Color(0xff1C1C25),
                  borderRadius: BorderRadius.circular(100.0)),
            ),
          ],
        ),
      ),
    );
  }
}
