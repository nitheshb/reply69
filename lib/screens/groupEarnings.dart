import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupEarnings extends StatefulWidget {
  @override
  _GroupEarningsState createState() => _GroupEarningsState();
}

class _GroupEarningsState extends State<GroupEarnings> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left: 18, right: 18, top: 34),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _contentHeader(),
            SizedBox(
              height: 38,
            ),
            Text(
              "Ads Monetize Earnings Overview",
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Color(0xff3A4276),
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            _contentOverView(),
            SizedBox(
              height: 34,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Terms and conditons: ",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Color(0xff3A4276),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Image.asset(
                  "assets/bar_code.png",
                  width: 16,
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),
          _termsAndConditions(),
            SizedBox(
              height: 34,
            ),
           
          
          ],
        ),
      ),
    );
  }
}

Widget _contentHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Row(
        children: <Widget>[
          SizedBox(
            width: 12,
          ),
          Text(
            "Chatogram",
            style: GoogleFonts.poppins(
              fontSize: 22,
              color: Color(0xff3A4276),
              fontWeight: FontWeight.w800,
            ),
          )
        ],
      ),
      Image.asset(
        "assets/menu.png",
        width: 16,
      )
    ],
  );
}

Widget _contentOverView() {
  return Container(
    padding: EdgeInsets.only(left: 18, right: 18, top: 22, bottom: 22),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Color(0xffF1F3F6)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "₹ 0.00",
              style: GoogleFonts.poppins(
                fontSize: 24,
                color: Color(0xff171822),
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "Current Ad Revenue",
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Color(0xff3A4276).withOpacity(.4),
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2ecc71),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  child: Text(
                                    "+ 0.0 %",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6),
                                 Text(
                "Revenue Growth",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ],
    ),
  );
}


Widget _termsAndConditions() {
  return Container(
    padding: EdgeInsets.only(left: 18, right: 18, top: 22, bottom: 22),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Color(0xffF1F3F6)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
               Text(
                "₹ Any Group owner is elgiable/start to earn revenue only when respective group followers limit is min 3000.",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "₹ All the reveue calculations will be done following the 'Google Admob Revenue Model'.",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "₹ Only the adds shown by 'Google Admobs' will be converted to Add Revenue.",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "₹ Billing Currency is Indian Rupee (INR ₹).                                              ",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
               
              Text(
                "₹ Min amount of Rs 1000 is required to redeem into your banking/ UPI account.                                               ",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
      ],
    ),
  );
}



class ModelServices {
  String title, img;

  ModelServices({this.title, this.img});
}