import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_ex/data.dart';
import 'package:flutter_app_ex/models/datas_.dart';
import 'package:flutter_app_ex/screens/home_screen.dart';
import 'package:flutter_app_ex/screens/nav_screen.dart';
import 'package:flutter_app_ex/widgets/video_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:video_player/video_player.dart';


final checkProvider = StateNotifierProvider<StatusCheck, bool>((ref) => StatusCheck());
class StatusCheck extends StateNotifier<bool>{
  StatusCheck() : super(false);


  void toggle(){
    state = !state;
  }

}


final showProvider = StateNotifierProvider<ControlCheck, bool>((ref) => ControlCheck());
class ControlCheck extends StateNotifier<bool>{
  ControlCheck() : super(true);


  void toggle(){
    state = false;
  }

}


class VideoPlay extends StatefulWidget {
  final bool status;
  final bool cCheck;
  final List<Data> dat;
  final Data video;
  final ChewieController control1;
  final void Function(int) tap;
  final ChewieController control2;
   VideoPlayerController controller;

  VideoPlay({this.status, this.cCheck, this.dat, this.control1, this.control2, this.tap, this.controller, this.video});
  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {

  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    widget.controller?.pause(); // mute instantly
    widget.controller?.dispose();
    widget.controller = null;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body:  Consumer(
          builder: (context, watch, build) {
            return widget.status ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              height: 70,
              child:   widget.control2 != null &&
                  widget.control2
                      .videoPlayerController.value.isInitialized
                  ? Container(
                child: Row(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Chewie(
                          controller: widget.control1
                      ),
                    ),
                    SizedBox(width: 9,),
                    Flexible(child: Text(widget.video.title, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                    Consumer(
                        builder: (context, watch, child) {
                          final checkPlay = watch(checkProvider);
                          return IconButton(
                            onPressed: () {
                              widget.control1.isPlaying ? widget.control1
                                  .pause() : widget.control2.play();
                              context.read(checkProvider.notifier).toggle();
                            },
                            icon: Icon(
                                widget.control1.isPlaying ? Icons.pause : Icons
                                    .play_arrow),
                          );
                        }
                    ),
                    Consumer(
                        builder: (context, watch, child) {
                          return IconButton(
                            onPressed: () {
                              context.read(videoProvider).state = null;
                              widget.control1.pause();
                              widget.control2.pause();
                              context.read(checkPlayerProvider.notifier).toggleState();
                            },
                            icon: Icon(Icons.close),
                          );
                        }
                    ),
                  ],
                ),
              )
                  : Center(
                child: Text('Loading'),
              ),
            ) :  GestureDetector(
              onTap: (){
                context
                    .read(playerProvider)
                    .state
                    .animateToHeight(state: PanelState.MAX);
              },
              child: SafeArea(
                child: Container(
                  child: CustomScrollView(
                    controller: _scrollController,
                    shrinkWrap: true,
                    slivers: [
                      SliverToBoxAdapter(
                          child:  Consumer(
                              builder: (context, watch, child) {
                                final selectedVideo = watch(videoProvider).state;
                                return Column(
                                  children: [
                                    widget.control1 != null &&
                                        widget.control1
                                            .videoPlayerController.value.isInitialized
                                        ?  Container(
                                      height: 238,
                                          width: double.infinity,
                                          child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Chewie(
                                            controller: widget.control2
                                      ),
                                    ),
                                        ) : Container(
                                      height: 238,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Center(child: CircularProgressIndicator()),
                                          SizedBox(height: 20),
                                          Text('Loading'),
                                        ],
                                      ),
                                    ),

                                    VideoInfo(video: selectedVideo),
                                  ],
                                );
                              }
                          )

                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final video = widget.dat[index];
                            return VideoCard(
                              video: video,
                              hasPadding: true,
                              onTaps: () => widget.tap(index),
                              onTap: () => _scrollController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeIn,
                              ),
                            );
                          },
                          childCount: widget.dat.length,
                        ),

                      )
                    ],

                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}