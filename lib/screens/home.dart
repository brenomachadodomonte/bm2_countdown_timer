import 'package:flutter/material.dart';
import 'package:countdowntimer/widgets/painter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  AnimationController controller;
  bool isPlaying = false;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
    controller.addStatusListener((status){
      if(status == AnimationStatus.dismissed){
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.center,
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: CustomPaint(
                                    painter: Painter(
                                      animation: controller,
                                      backgroundColor: Colors.black12,
                                      color: Colors.green,
                                    )),
                              ),
                              Align(
                                alignment: FractionalOffset.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "BM2\nCountDownTimer",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20.0,color: Colors.black54),
                                    ),
                                    Text(timerString,style: TextStyle(fontSize: 100.0,color: Colors.black54),),
                                    FlatButton(
                                      child: Text('RESET',style: TextStyle(fontSize: 20.0,color: Colors.black54),),
                                      onPressed: (){
                                        controller.reset();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        FloatingActionButton.extended(
                          label: Text(isPlaying ? 'Pause' : 'Play'),
                          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                          onPressed: (){
                            if(controller.isAnimating) {
                              controller.stop();
                            } else {
                              controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
                            }
                            setState(() {
                              isPlaying = !isPlaying;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
          }),
    );
  }
}
