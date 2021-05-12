import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_ex/data.dart';
import 'package:flutter_app_ex/data_provider/data_fetch.dart';
import 'package:flutter_app_ex/models/datas_.dart';
import 'package:flutter_app_ex/screens/nav_screen.dart';
import 'package:flutter_app_ex/widgets/video_play.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';


List<Data> dat = [];
Data vid;

final checkPlayerProvider = StateNotifierProvider<CheckPlayer,bool>((ref) => CheckPlayer());

class CheckPlayer extends StateNotifier<bool>{
  CheckPlayer() : super(true);

  void toggleState(){
    state = !state;
  }

  void changeState(){
    state = false;
  }

}

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  VideoPlayerController _controller;
  ChewieController _chewieController;
  ChewieController chewieControllers;




  int _playingIndex = -1;
  bool _disposed = false;

  bool _showingDialog = false;


  bool _playing = false;
  bool get _isPlaying {
    return _playing;
  }



  @override
  void initState() {
    Wakelock.enable();
    super.initState();
  }

  @override
  void dispose() {
    _disposed = true;
    Wakelock.disable();
    _controller?.pause(); // mute instantly
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  Future<void> _initializeAndPlay(int index) async {
    print("_initializeAndPlay ---------> $index");
    final song = dat[index];

    final controller = VideoPlayerController.network(song.videoUrl);
    final cController = ChewieController(
        videoPlayerController: controller,
        autoPlay: false
    );

    final dController = ChewieController(
      videoPlayerController: controller,
      autoPlay: false,
      showControls: false,
    );
    // final old = _controller;
    // _controller = controller;

    final old = _chewieController;
    _chewieController = cController;

    final old1 = chewieControllers;
    chewieControllers = dController;

    if (old != null) {
      old.removeListener(_onControllerUpdated);
      old.pause();
      debugPrint("---- old contoller paused.");
    }

    if (old1 != null) {
      old1.removeListener(_onControllerUpdated);
      old1.pause();
      debugPrint("---- old contoller paused.");
    }

    debugPrint("---- controller changed.");
    setState(() {});

    controller
      ..initialize().then((_) {
        debugPrint("---- controller initialized");
        old?.dispose();
        old1?.dispose();
        _playingIndex = index;
        cController.videoPlayerController.addListener(_onControllerUpdated);
        cController.videoPlayerController.play();
        dController.videoPlayerController.addListener(_onControllerUpdated);
        dController.videoPlayerController.play();
        setState(() {});
      });

  }


  void _onControllerUpdated() async {
    if (_disposed) return;
    // blocking too many updation
    // important !!


    final controller = _chewieController;
    if (controller == null) return;
    if (!controller.videoPlayerController.value.isInitialized) return;


    final playing = controller.isPlaying;
    if (playing) {
      // handle progress indicator
      if (_disposed) return;
    }

    // handle clip end
    if (_isPlaying != playing ) {


      if (!playing) {
        debugPrint(
            "========================== End of Clip / Handle NEXT ========================== ");
        final isComplete = _playingIndex == videos.length - 1;
        if (isComplete) {
          print("played all!!");
          if (!_showingDialog) {
            _showingDialog = true;
          } else {
            _initializeAndPlay(_playingIndex + 1);
          }
        }
      }
    }
  }






  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Consumer(
          builder: (context, watch,child) {
            final selectedVideo = watch(videoProvider).state;
            final player = watch(playerProvider).state;
            final data = watch(dataProvider);
            final playerCheck = watch(checkPlayerProvider);
            return Stack(
              children: [
                data.maybeWhen(
                    data: (data) {
                      dat = data;
                      return CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            floating: true,
                            backgroundColor: Colors.black87,
                            leadingWidth: 100.0,
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Image.asset('assets/yt_logo_dark.png'),
                            ),
                          ),
                          SliverPadding(
                              padding: playerCheck ? const EdgeInsets.all(0)
                                  : const EdgeInsets.only(bottom: 60.0),
                              sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate((context,
                                      index) {
                                    final video = data[index];
                                    vid = video;
                                    return VideoCard(video: video, tap: _initializeAndPlay, index: index);
                                  },
                                      childCount: data.length
                                  )
                              )
                          ),
                        ],
                      );
                    },
                    orElse: () => Center(child: CircularProgressIndicator(),)),
                Offstage(
                  offstage: selectedVideo == null,
                  child: Miniplayer(
                      controller: player,
                      minHeight: 60.0,
                      maxHeight: 1000.0,
                      builder: (height, percent) {
                        if (selectedVideo == null)
                          return const SizedBox.shrink();
                        if (height <= 60.0 + 50.0)
                          return VideoPlay(status: true,
                            video: selectedVideo,
                            dat: dat,
                            control1: chewieControllers, control2: _chewieController, tap: _initializeAndPlay, controller: _controller,);
                        return VideoPlay(status: false, dat: dat, control1: chewieControllers, controller: _controller,
                          control2: _chewieController,
                          video: selectedVideo,
                          tap: _initializeAndPlay,);
                      }
                  ),
                ),
              ],
            );
          }
        ),
    );
  }
}

class VideoCard extends StatelessWidget {
  final Data video;
  final bool hasPadding;
  final VoidCallback onTap;
  final VoidCallback onTaps;
  final int index;
  final void Function(int) tap;


  VideoCard({this.video, this.onTap, this.hasPadding, this.onTaps, this.tap, this.index});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        context.read(videoProvider).state = video;
        context.read(checkProvider.notifier).toggle();
        context.read(playerProvider).state.animateToHeight(state: PanelState.MAX);
        context.read(checkPlayerProvider.notifier).changeState();

        if (onTap != null) onTap();
        if (onTaps != null){
          onTaps();
        } else{
          tap(index);
        }
      },
      child: Column(
        children: [
          Stack(
            children: [
              Image.network(
                video.imageUrl,height: 220, width: double.infinity, fit: BoxFit.cover,),
              Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                      padding: const EdgeInsets.all(2),
                      color: Colors.black,
                      child: Text(
                        video.duration, style: TextStyle(color: Colors.white),))
              ),

            ],
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(video.title,  overflow: TextOverflow.ellipsis, maxLines: 2,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black87 ), textAlign: TextAlign.start,),
            ),
          ),
        ],
      ),
    );
  }
}
