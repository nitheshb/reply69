import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notification/app_theme.dart';
import 'package:notification/util/const.dart';
class MatchDetails extends StatefulWidget {
  @override
  _MatchDetailsState createState() => _MatchDetailsState();
}

class _MatchDetailsState extends State<MatchDetails> {
  Color color2=Color(0xffE9FBFF);
  Color color1=Color(0xFF909090);
  final style1=TextStyle(
  fontSize: 18,
  color: Colors.black,
  fontWeight: FontWeight.w800,
  );

  final style7=TextStyle(
    fontSize: 15,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );

  final style2=TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.w800,
  );
  final style3= TextStyle(
  fontSize: 12.5,
  color: Color(0xFF909090),
  fontWeight: FontWeight.w400,
  );
  final style4=TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );
  final style5=TextStyle(
    fontSize: 14,
    color: Colors.deepOrange,
    fontWeight: FontWeight.w900,
  );

  final style6=TextStyle(
    fontSize: 16,
    color: Color(0xFF98C4D8),
    fontWeight: FontWeight.w700,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff001240),
        iconTheme: IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('ACC vs GCC',style: style2
            ),
            Text('Twenty20',style: style3
            ),
          ],
        ),
        ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                   color: Constants.lightPrimary,
                    boxShadow: [
                      BoxShadow(
                        color: color1.withOpacity(0.4),
                        blurRadius: 9.0,
                        spreadRadius: 1.0,
                      ),
                    ]
                ),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Row(
                       children: <Widget>[
                         Image.asset('assets/stadium.png',width: 29,height: 29,color: Colors.grey[600],),
                         SizedBox(width: 15,),
                         Text('Venue',style: style1,),
                       ],
                      ),
                    ),
                    Divider(height: 3,color: color1.withOpacity(0.8),),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:12.5,vertical: 8),
                      child: Text('Abu Dhabi',style: style3),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:12.5),
                      child: Text('Sheikh Zayed Stadium',style: style4),
                    ),
                    SizedBox(height: 13,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:12.5,vertical: 8),
                              child: Text('Pitch Behaviour',style: style3),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:12.5),
                              child: Text('Balanced',style: style4),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right:28.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:12.5,vertical: 8),
                                child: Text('Avg Score',style: style3),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:12.5),
                                child: Text('156',style: style4),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 13,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:12.5,vertical: 8),
                              child: Text('Weather Report',style: style3),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:12.5),
                              child: Text('Clear Sky',style: style4),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right:15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:12.5,vertical: 8),
                                child: Text('Temperature',style: style3),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:12.5),
                                child: Text('34.29°',style: style4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Divider(height: 15,color: color1.withOpacity(0.8),),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:12.5,vertical: 8),
                          child: Text('SEE TOP PLAYERS AT THIS VENUE',style: style5,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(Icons.arrow_forward_ios,size: 15,color: color1,),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 3),
              child: Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: color2,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:12.5,vertical: 8),
                      child: Text('Make teams like a pro!',style: style6,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(Icons.arrow_forward_ios,size: 15,color: Color(0xFF98C4D8),),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 270,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Constants.lightPrimary,
                    boxShadow: [
                      BoxShadow(
                        color: color1.withOpacity(0.4),
                        blurRadius: 9.0,
                        spreadRadius: 1.0,
                      ),
                    ]
                ),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Row(
                        children: <Widget>[
                          Image.asset('assets/linechart.png',width: 23,height: 23,color: Colors.grey[600],),
                          SizedBox(width: 15,),
                          Text('Player Stats',style: style1,),
                        ],
                      ),
                    ),
                    Divider(height: 3,color: color1.withOpacity(0.8),),
                    

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xffF5F5F5),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:12.5,vertical: 8),
                              child: Text('TOP PLAYER',style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF909090),
                                fontWeight: FontWeight.w600,
                              ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text('AVG FPC',style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF909090),
                                fontWeight: FontWeight.w600,
                              ),),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:20,vertical: 8),
                          child: Text('M Siddharth',style: style7),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:20,vertical: 8),
                          child: Text('(BOWL)',style: style3),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                          child: Text('9.5',style: style7),
                        ),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:20,vertical: 8),
                          child: Text('S Mavi',style: style7),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:20,vertical: 8),
                          child: Text('(BOWL)',style: style3),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                          child: Text('9',style: style7),
                        ),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:20,vertical: 8),
                          child: Text('N Rana',style: style7),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:20,vertical: 8),
                          child: Text('(AR)',style: style3),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                          child: Text('7.5',style: style7),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Divider(height: 15,color: color1.withOpacity(0.8),),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:12.5,vertical: 8),
                          child: Text('SEE ALL PLAYER STATS',style: style5,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(Icons.arrow_forward_ios,size: 15,color: color1,),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
