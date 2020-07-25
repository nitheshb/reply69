import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

// import 'package:quick_park/Paint/CustomPaintHome.dart';
// import 'package:quick_park/Transitions/FadeTransition.dart';
// import 'package:quick_park/Pages/map.dart';
// import 'package:quick_park/Widget/recents.dart';

class powerPredictor extends StatefulWidget {
  @override
  _powerPredictorState createState() => _powerPredictorState();
}

class _powerPredictorState extends State<powerPredictor> with TickerProviderStateMixin {
   AnimationController _longPressController;
   Animation<double> longPressAnimation;
   String selectedValue;
   String ballNo;
  @override
    void initState() {
    // TODO: implement initState
    super.initState();
     _longPressController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
       longPressAnimation =
        Tween<double>(begin: 1.0, end: 2.0).animate(CurvedAnimation(
            parent: _longPressController,
            curve: Interval(
              0.1,
              1.0,
              curve: Curves.fastOutSlowIn,
            )));
    }
  Widget ScoreCard(){
    return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 4),
              child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 6,
                  color: Colors.white.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14, top:14),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title:  Column(
                            children: <Widget>[
                              Row( 
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'DD',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17.5,
                                        letterSpacing: 0.2
                                    ),
                                  ),
                                 
                                   Text(
                                    '181/4(20)',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17.5,
                                        letterSpacing: 0.2
                                    ),
                                  ),
                                   
                                ],
                              ),
                              SizedBox(height:20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'RCB',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17.5,
                                        letterSpacing: 0.2
                                    ),
                                  ),
                                  
                                   Text(
                                    '',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17.5,
                                        letterSpacing: 0.2
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                         
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 12.0),
                              //   child: StarRating(
                              //     size: 20,
                              //     color: Colors.yellow[600],
                              //     rating: recentList[index].rating,
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0, left:14),
                                child: Text(
                                  '\u20B9 100',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 17
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
              ),
            );
  }
    Widget ball2BallView(){
    return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 4),
              child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 6,
                  color: Colors.white.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14, top:14, left:14),
                    child:         Container(
                    height: 70.0,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 55.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: index == 0 ? Color(0xFF00003f) :  Color(0xFFffe5b4),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                6.toString(),
                                style: TextStyle(
                                    color: index == 0 ? Colors.white : Color(0xFF00003f),
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "4.1",
                                style: TextStyle(
                                    color: index == 0 ? Colors.white: Color(0xFF00003f),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: 15.0,
                        );
                      },
                      itemCount: 6,
                    ),
                  ),
              
                  )
              ),
            );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          TopBar_home(),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: AppBar(
                
                  title: Center(
                    child: Text(
                      'BID365-Predictions',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Quickstand'
                      ),
                    ),
                  ),
               
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ),
       
              ScoreCard(),
              // ball2BallView(),
               Padding(
                padding: const EdgeInsets.only(left: 6,top: 10,right: 6,bottom: 10),
                child: QuestionCard(),
                
               ),
               Visibility(
                 visible: selectedValue != null,
                 child:
              selectedValue == 'out' ?
               resultCard(context, selectedValue,'out', Color(0xff7dc13a)) : resultCard(context,selectedValue,'out', Color(0xfff9a13f)) 
          ),
                            
           
            ],
          )
        ],
      ),
    );
  }

  Widget QuestionCard(){
    return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                    child: Column(
                        children: <Widget>[
                             GestureDetector(

                                                  onTapUp: (detail) {
                                                  setState(() {
                                                      selectedValue = null;
                                                    });
                                                    // if(selectedValue == null){
                                                    //   print('value is null');
                                                    // setState(() {
                                                    //   selectedValue = 'boundary';
                                                    // });
                                                    // }
                                                    print('setting value ${selectedValue != 'boundary'} , ${selectedValue != null}');
                                                   
                                                  },
                                                  child:
                           Text('Round-4'),
                             ),
                           Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Column(
                        children: <Widget>[
                            Visibility(
                                    visible: selectedValue !=null,
                                    child:
                          Text(
                              'You have selected ${selectedValue} (3.1)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                            ),
                             Visibility(
                                    visible: selectedValue ==null,
                                    child:
                          Text(
                              'What will happen in next ball? (3.1)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                            ),
                        SizedBox(height:9),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Container(
                                 
                                  // height: 100.0,
                                  child: Column(
                                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                                    // mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        // height: 150.0,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                GestureDetector(

                                                  onTapUp: (detail) {
                                                    // Navigator.of(context).push(
                                                    //     MaterialPageRoute(
                                                    //         builder:
                                                    //             (BuildContext context) =>
                                                    //                 LastPage(
                                                    //                   statusType: 'Unhappy',
                                                    //                 )));
                                                    if(selectedValue == null){
                                                      print('value is null');
                                                    setState(() {
                                                      selectedValue = 'out';
                                                    });
                                                    }
                                                    print('out value ${selectedValue != 'out'} , ${selectedValue != null}');
                                                    print('boundary value ${selectedValue != 'boundary'} , ${selectedValue != null}');
                                                    print('run value ${selectedValue != 'boundary'} , ${selectedValue != null}');
                                                    //  setState(() {
                                                    //   selectedValue = 'out';
                                                    // });
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Visibility(
                                                        visible: (selectedValue ==null || selectedValue == 'out'),
                                                        child: 
                                                      Image.asset(
                                                              'assets/images/out.PNG',
                                                              width: 70.0,
                                                              height: 70.0,
                                                            ),
                                                      ),
                                                       Visibility(
                                                        visible: (selectedValue != 'out' && selectedValue != null),
                                                        child: 
                                                      Image.asset(
                                                              'assets/images/out_fade.PNG',
                                                              width: 70.0,
                                                              height: 70.0,
                                                            ),
                                                      )
                                                    ],
                                                  )
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: Text('+150'),
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: <Widget>[
                                                 GestureDetector(

                                                  onTapUp: (detail) {
                                                  
                                                    if(selectedValue == null){
                                                      print('value is null');
                                                    setState(() {
                                                      selectedValue = 'boundary';
                                                    });
                                                    }
                                                    print('setting value ${selectedValue != 'boundary'} , ${selectedValue != null}');
                                                   
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Visibility(
                                                        visible: (selectedValue ==null || selectedValue == 'boundary'),
                                                        child: 
                                                      Image.asset(
                                                              'assets/images/boundary.PNG',
                                                              width: 70.0,
                                                              height: 70.0,
                                                            ),
                                                      ),
                                                       Visibility(
                                                        visible: (selectedValue != 'boundary' && selectedValue != null),
                                                        child: 
                                                      Image.asset(
                                                              'assets/images/boundary_fade.PNG',
                                                              width: 70.0,
                                                              height: 70.0,
                                                            ),
                                                      )
                                                    ],
                                                  )
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: Text('+50'),
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: <Widget>[
                                                 GestureDetector(
//                          
                                                  onTapUp: (detail) {
                                                   
                                                    if(selectedValue == null){
                                                      print('value is null');
                                                    setState(() {
                                                      selectedValue = 'run';
                                                    });
                                                    }
                                                    print('setting value ${selectedValue != 'run'} , ${selectedValue != null}');
                                                    ;
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Visibility(
                                                        visible: (selectedValue ==null || selectedValue == 'run'),
                                                        child: 
                                                      Image.asset(
                                                              'assets/images/run.PNG',
                                                              width: 70.0,
                                                              height: 70.0,
                                                            ),
                                                      ),
                                                       Visibility(
                                                        visible: (selectedValue != 'run' && selectedValue != null),
                                                        child: 
                                                      Image.asset(
                                                              'assets/images/run_fade.PNG',
                                                              width: 70.0,
                                                              height: 70.0,
                                                            ),
                                                      )
                                                    ],
                                                  )
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: Text('+10'),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height:18),
                                  
                                  Visibility(
                                    visible: selectedValue !=null,
                                    child:
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'Waiting for the result',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              SizedBox(width:6),
                                                 Container(
                                                        width: 12,
                                                        height: 12,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2.0,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                  ),
                                  Visibility(
                                    visible: selectedValue == null,
                                    child: 
                                      _AnimatedLiquidLinearProgressIndicator(),
                                  )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ],
                      )),
                          
                        ],
                      ),
                  ),
                );
  }
  Widget resultCard(context,selectedValue,resultValue, colorText){
    print('result is $colorText');
    String encourageText;

    selectedValue == resultValue ? encourageText='You are Great Predictor..!' : encourageText='Stay foucs';
    return Card(
      color:colorText,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                    child: Column(
                        children: <Widget>[
                             GestureDetector(

                                                  onTapUp: (detail) {
                                                  setState(() {
                                                      selectedValue = null;
                                                    });
                                                    // if(selectedValue == null){
                                                    //   print('value is null');
                                                    // setState(() {
                                                    //   selectedValue = 'boundary';
                                                    // });
                                                    // }
                                                    print('setting value ${selectedValue != 'boundary'} , ${selectedValue != null}');
                                                   
                                                  },
                                                  child:
                           Text('Round-4'),
                             ),
                           Container(
                      margin: EdgeInsets.only(top: 6.0),
                      child: Column(
                        children: <Widget>[
                           
                        SizedBox(height:0),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Container(
                                 
                                  // height: 100.0,
                                  child: Column(
                                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                                    // mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        // height: 150.0,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            // first image
                                            Visibility(
                                              visible: resultValue == 'out',
                                              child: 
                                            Column(
                                              children: <Widget>[
                                                  Image.asset(
                                                              'assets/images/out.PNG',
                                                              width: 90.0,
                                                              height: 90.0,
                                                            ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: Text('+150'),
                                                )
                                              ],
                                            ),
                                            ),
                                            // second icon
                                               Visibility(
                                              visible: resultValue == 'boundary',
                                              child: 
                                            Column(
                                              children: <Widget>[
                                                  Image.asset(
                                                              'assets/images/boundary.PNG',
                                                              width: 90.0,
                                                              height: 90.0,
                                                            ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: Text('+50'),
                                                )
                                              ],
                                            ),
                                            ),
                                            // third icon
                                            Visibility(
                                              visible: resultValue == 'run',
                                              child: 
                                            Column(
                                              children: <Widget>[
                                                  Image.asset(
                                                              'assets/images/run.PNG',
                                                              width: 90.0,
                                                              height: 90.0,
                                                            ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: Text('+10'),
                                                )
                                              ],
                                            ),
                                            ),


                                          ],
                                        ),
                                      ),
                                      SizedBox(height:18),
                                  
                                  Visibility(
                                    visible: selectedValue !=null,
                                    child:
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  '$encourageText',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                             
                                              ],
                                            ),
                                  ),
                                
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ],
                      )),
                          
                        ],
                      ),
                  ),
                );
  }

}




class TopBar_home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(
        height: 400,
      ),
      painter: HomePainter(),
    );
  }
}

class HomePainter extends CustomPainter{

  Color colorOne = Colors.red;
  Color colorTwo = Colors.red[300];
  Color colorThree = Colors.red[100];

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();


    path.lineTo(0, size.height *0.75);
    path.quadraticBezierTo(size.width* 0.10, size.height*0.70,   size.width*0.17, size.height*0.90);
    path.quadraticBezierTo(size.width*0.20, size.height, size.width*0.25, size.height*0.90);
    path.quadraticBezierTo(size.width*0.40, size.height*0.40, size.width*0.50, size.height*0.70);
    path.quadraticBezierTo(size.width*0.60, size.height*0.85, size.width*0.65, size.height*0.65);
    path.quadraticBezierTo(size.width*0.70, size.height*0.90, size.width, 0);
    path.close();

    paint.color = colorThree;
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(0, size.height*0.50);
    path.quadraticBezierTo(size.width*0.10, size.height*0.80, size.width*0.15, size.height*0.60);
    path.quadraticBezierTo(size.width*0.20, size.height*0.45, size.width*0.27, size.height*0.60);
    path.quadraticBezierTo(size.width*0.45, size.height, size.width*0.50, size.height*0.80);
    path.quadraticBezierTo(size.width*0.55, size.height*0.45, size.width*0.75, size.height*0.75);
    path.quadraticBezierTo(size.width*0.85, size.height*0.93, size.width, size.height*0.60);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = colorTwo;
    canvas.drawPath(path, paint);

    path =Path();
    path.lineTo(0, size.height*0.75);
    path.quadraticBezierTo(size.width*0.10, size.height*0.55, size.width*0.22, size.height*0.70);
    path.quadraticBezierTo(size.width*0.30, size.height*0.90, size.width*0.40, size.height*0.75);
    path.quadraticBezierTo(size.width*0.52, size.height*0.50, size.width*0.65, size.height*0.70);
    path.quadraticBezierTo(size.width*0.75, size.height*0.85, size.width, size.height*0.60);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = colorOne;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

}




class _AnimatedLiquidLinearProgressIndicator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      _AnimatedLiquidLinearProgressIndicatorState();
}

class _AnimatedLiquidLinearProgressIndicatorState
    extends State<_AnimatedLiquidLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = _animationController.value * 10;
    return Center(
      child: Container(
        width: double.infinity,
        height: 20.0,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: LiquidLinearProgressIndicator(
          value: _animationController.value,
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Colors.blue),
          borderRadius: 14.0,
          center: Text(
            "${percentage.toStringAsFixed(0)}sec",
            style: TextStyle(
              color: Colors.lightBlueAccent,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}