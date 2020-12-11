import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notification/controllers/firebaseController.dart';

class GroupEarnings extends StatefulWidget {
   GroupEarnings({Key key,
    this.userId,
})
      : super(key: key);
      final String userId;
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
              height: 18,
            ),
            Text(
              "Earning Overview",
              style: GoogleFonts.lato(
                fontSize: 15,
                color: Color(0xff3A4276),
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
            child:
            StreamBuilder(
                      stream: FirebaseController.instanace
                          .fetchRevenuDetails(widget.userId),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error ${snapshot.error}');
                        }
                        if (snapshot.hasData) {
                          DocumentSnapshot ds = snapshot.data;
                        print('dsis ${ds.data}');
                        var walletMoney = ds.data['walletMoney'] ?? 0;
                        var membershipAmount = ds.data['membershipAmount'] ?? 0;
                        var applauseAmount = ds.data['applauseAmount'] ?? 0;
                        var adRevenueAmount = ds.data['adRevenueAmount']??0;
                         
                        return  _contentOverView(walletMoney,membershipAmount ,applauseAmount, adRevenueAmount);
                        }}),
            ),
            SizedBox(
              height: 34,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "How to Earn ",
                  style: GoogleFonts.lato(
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
          _howtoEarn(),
            SizedBox(
              height: 34,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Terms and conditons: ",
                  style: GoogleFonts.lato(
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
            width: 2,
            height: 50
          ),
          Text(
            "TopExperts",
            style: GoogleFonts.lato(
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

Widget _contentOverView(walletMoney,membershipAmount ,applauseAmount, adRevenueAmount) {
  return Container(
    padding: EdgeInsets.only(left: 18, right: 18, top: 22, bottom: 22),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Color(0xffF1F3F6)),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "₹ $walletMoney",
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    color: Color(0xff171822),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "Total Revenue",
                  style: GoogleFonts.lato(
                      fontSize: 15,
                      color: Color(0xff3A4276).withOpacity(.4),
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                InkWell(
                  onTap: (){
                    if(walletMoney <=999){
                     Fluttertoast.showToast(msg: "Min of Rs1,000 is required to bank transfer", backgroundColor: Colors.black, textColor: Colors.white);
                  }
                  },
                  child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFF2ecc71),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        child: Text(
                                          "Transfer",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                ),
                                    SizedBox(height: 6),
                                     Text(
                    "Redeem to Bank Account",
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Color(0xff3A4276),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ),
        SizedBox(height: 14),
        Divider(),
         SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            earningDetailsCard('Applause Revenue',applauseAmount),
            earningDetailsCard('Prime Revenue', membershipAmount),
            earningDetailsCard('Ad Revenue', adRevenueAmount),
          ],
        ),
       
      ],
    ),
  );
}

Widget earningDetailsCard(earnCategoy, earnCategoryAmount){
  return         Column(
              children: <Widget>[
                Container(
                                      decoration: BoxDecoration(
                                        //color: Color(0xFF2ecc71),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      child: Text(
                                        "₹ $earnCategoryAmount",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                     Text(
                    "$earnCategoy",
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Color(0xff3A4276),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
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
                "* Any Group owner is elgiable/start to earn add revenue only when respective group followers limit is min 3000.",
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w500,
                ),
              ),
            
              SizedBox(height: 10),
              Text(
                "* Only the adds shown by 'Google Admobs' will be converted to Add Revenue.",
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "* If user payement is done through credit card/upi/debit card a bank processing charge of 2% will be charged.                                              ",
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
               
              Text(
                "* Min amount of Rs 1000 and bank account approval by TopExerts is required to redeem into your banking/ UPI account.                                               ",
                style: GoogleFonts.lato(
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


Widget _howtoEarn() {
  return Container(
    padding: EdgeInsets.only(left: 18, right: 18, top: 22, bottom: 22),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Color(0xffF1F3F6)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
               Text(
                "₹ APPLAUSE amount will be send by non-prime user of your group when he/she feels to apppreciate/thank your work ",
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "₹ PRIME amount will be send when a new user subscibers to your prime group",
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "₹ AD-REVENUE will be generated based on users engagement on your group page as per 'Google Admobs'",
                style: GoogleFonts.lato(
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