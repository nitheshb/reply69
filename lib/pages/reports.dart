import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notification/util/auth.dart';
import 'package:notification/util/validators.dart';
import 'package:notification/widgets/loading.dart';
import 'package:flutter/material.dart';
// import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';


class ReportScreen extends StatefulWidget {
  ReportScreen({
    Key key,
    this.chatId,
    this.uId,
  }) : super(key: key);
  final String uId, chatId;
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = new TextEditingController();

  bool _autoValidate = false;
  bool _loadingVisible = false;
  bool _enabled = false;
  @override
  void initState() {
    super.initState();
  }

  String _selected;
  List<Map> _myJson = [
    {"id": '1', "image": "assets/banks/affinbank.png", "name": "Payment"},
    {"id": '2', "image": "assets/banks/ambank.png", "name": "Content"},
    {"id": '3', "image": "assets/banks/bankislam.png", "name": "Others"},
  ];

  Widget stateSelection() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    isDense: true,
                    hint: new Text("Select State"),
                    value: _selected,
                    onChanged: (String newValue) {
                      setState(() {
                        _selected = newValue;
                      });
                    },
                    items: _myJson.map((Map map) {
                      return new DropdownMenuItem<String>(
                        value: map["id"].toString(),
                        // value: _mySelection,
                        child: Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(map["name"])),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 60.0,
          child: ClipOval(
            child: Image.asset(
              'assets/images/default.png',
              fit: BoxFit.cover,
              width: 120.0,
              height: 120.0,
            ),
          )),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _email,
      maxLines: 8,

      //  validator: Validator.validateEmail,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            FontAwesomeIcons.pagelines,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: _enabled ? 'Enter your reason here' : '${_email.text}',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.0)),
      ),
    );

    final ReportSubmitButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        onPressed: () {
          _forgotPassword(email: _email.text, context: context);
        },
        padding: EdgeInsets.all(12),
        color: Colors.green,
        child: Text('Submit', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Report"),
        centerTitle: true,
      ),
      body: LoadingScreen(
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // logo,
                      SizedBox(height: 10.0),
                      stateSelection(),
                      SizedBox(height: 12.0),
                      _enabled
                          ? email
                          : new FocusScope(
                              node: new FocusScopeNode(), child: email),

                      SizedBox(height: 12.0),
                      ReportSubmitButton,
                    ],
                  ),
                ),
              ),
            ),
          ),
          inAsyncCall: _loadingVisible),
    );
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  void _forgotPassword({String email, BuildContext context}) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (_formKey.currentState.validate()) {
      try {
        await _changeLoadingVisible();
        await Auth.addReportData(
            widget.uId, widget.chatId, _selected, _email.text);
        {
          setState(() {
            _enabled = !_enabled;
          });
        }
        await _changeLoadingVisible();
        Auth.showBasicsFlash(
            context: context,
            duration: Duration(seconds: 4),
            messageText: 'Reported Successfully');
      } catch (e) {
        _changeLoadingVisible();

        String exception = Auth.getExceptionText(e);
        // Fluttertoast.showToast(msg: "Reported Successfully ${exception}");
        // Flushbar(
        //   title: "Forgot Password Error",
        //   message: exception,
        //   duration: Duration(seconds: 10),
        // )..show(context);
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }
}
