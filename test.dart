import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auth_app_3fac/Home/home_screen.dart';
import 'package:auth_app_3fac/model/login_model.dart';
import 'package:auth_app_3fac/settings/sound_settings.dart';
import 'package:auth_app_3fac/utils/changeURL.dart';
import 'package:auth_app_3fac/utils/color.dart';
import 'package:auth_app_3fac/utils/constants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;

class LoginPage extends StatefulWidget {
  LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();
  bool visible = false;
  var alert_msg = "";
  bool isLoading = false;
  FocusNode textSecondFocusNode = new FocusNode();
  String? token;
  String? deviceId;
  String? deviceModel;
  String? brand;
  bool focus = false;
  String? username;
  String? userinfo;

  final spinkit = const SpinKitPouringHourGlass(
      strokeWidth: 2,
      color: maincolor,
      size: 50.0,
      duration: Duration(seconds: 4));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context)
        .size
        .shortestSide; // get the shortest side of device
    final bool useMobileLayout = shortestSide < 600.0;

    return WillPopScope(
        onWillPop: () async => exit(1),
        child: MaterialApp(
            scaffoldMessengerKey: snackbarKey,
            debugShowCheckedModeBanner: false,
            builder: (context, child) => ResponsiveWrapper.builder(
                BouncingScrollWrapper.builder(context, child!),
                maxWidth: 1200,
                minWidth: 450,
                defaultScale: true,
                breakpoints: [
                  const ResponsiveBreakpoint.resize(450, name: MOBILE),
                  const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                  const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                  const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                  const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
                ],
                background: Container(color: Colors.white)),
            home: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                iconTheme: IconThemeData(color: Colors.white, opacity: 1),
                toolbarHeight: Device.get().isTablet ? 80 : 70,
                backgroundColor: Colors.white,
                elevation: 0,
                toolbarOpacity: 1,
                title: Text(
                  "",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              body: isLoading
                  ? Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: Device.get().isTablet
                                  ? MediaQuery.of(context).size.width * 0.64
                                  : 300,
                              width: MediaQuery.of(context).size.width * 1.5,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image:
                                          AssetImage('assets/images/ERP.png'),
                                      fit: BoxFit.fitHeight)),
                              child: Stack(
                                children: <Widget>[],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(30.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      // boxShadow: const [
                                      //   BoxShadow(
                                      //       color: Color.fromRGBO(
                                      //           153, 158, 251, .4),
                                      //       blurRadius: 50.0,
                                      //       offset: Offset(10, 30))]
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              border: Border(
                                                  bottom:
                                                      BorderSide(color: grey),
                                                  top: BorderSide(color: grey),
                                                  left: BorderSide(color: grey),
                                                  right:
                                                      BorderSide(color: grey))),
                                          child: TextField(
                                            controller: _username,

                                            // textInputAction:
                                            //     TextInputAction.next,
                                            // onEditingComplete: () =>
                                            //     FocusScope.of(context)
                                            //         .nextFocus(),
                                            onSubmitted: (String value) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      textSecondFocusNode);
                                            },
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.person_outlined,
                                                  color: maincolor,
                                                ),
                                                border: InputBorder.none,
                                                hintText: "User ID",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[400])),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              border: Border(
                                                  bottom:
                                                      BorderSide(color: grey),
                                                  top: BorderSide(color: grey),
                                                  left: BorderSide(color: grey),
                                                  right:
                                                      BorderSide(color: grey))),
                                          padding: EdgeInsets.all(8.0),
                                          child: TextField(
                                            obscureText: visible,
                                            controller: _password,
                                            focusNode: textSecondFocusNode,
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                    color: maincolor,
                                                    Icons.password_outlined),
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    !visible
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: !visible
                                                        ? maincolor
                                                        : grey,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      visible = !visible;
                                                    });
                                                  },
                                                ),
                                                border: InputBorder.none,
                                                hintText: "Password",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[400])),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        if (_password.text.isNotEmpty &&
                                            _username.text.isNotEmpty) {
                                          SharedPreferences pref =
                                              await SharedPreferences
                                                  .getInstance();
                                          var user = encrypter
                                              .encrypt(_username.text, iv: iv);
                                          pref.setString(
                                              "userName", user.base64);
                                          setState(() {
                                            isLoading = true;

                                            verifyLogin();
                                          });
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          //print("empty");

                                          const snackBar = SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                              'These feilds should not be empty',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                          snackbarKey.currentState
                                              ?.showSnackBar(snackBar);
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(snackBar);

                                        }

                                        //print("Hello Click ME login?");
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          color: maincolor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Log In",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: fontsizeLarge,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  // InkWell(
                                  //   onTap: () {
                                  //     setState(() {
                                  //       const snackBar = SnackBar(
                                  //         backgroundColor: Colors.red,
                                  //         content: Text(
                                  //           'This feature is currently unavailable!',
                                  //           style:
                                  //               TextStyle(color: Colors.white),
                                  //         ),
                                  //       );
                                  //       snackbarKey.currentState
                                  //           ?.showSnackBar(snackBar);
                                  //     });
                                  //   },
                                  //   child: Text(
                                  //     "Forgot Password?",
                                  //     style:
                                  //         TextStyle(color: blue, fontSize: 16),
                                  //   ),
                                  // ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    version,
                                    style: TextStyle(color: grey, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              // drawer: Container(
              //   width: MediaQuery.of(context).size.width * 0.6,
              //   child: Drawer(
              //     backgroundColor: Colors.white,
              //     child: ListView(
              //       padding: EdgeInsets.all(5),
              //       children: [
              //         SizedBox(
              //           height: MediaQuery.of(context).size.height * 0.27,
              //           child: DrawerHeader(
              //               decoration: BoxDecoration(
              //                 border: Border.all(
              //                     color: Colors.white,
              //                     style: BorderStyle.solid),
              //                 color: Colors.white,
              //               ),
              //               child: Column(
              //                 children: [
              //                   Image.asset(
              //                     'assets/images/authen.png',
              //                     width: Device.get().isPhone
              //                         ? MediaQuery.of(context)
              //                                 .size
              //                                 .width *
              //                             0.30
              //                         : MediaQuery.of(context)
              //                                 .size
              //                                 .width *
              //                             0.26,
              //                     height: Device.get().isPhone
              //                         ? MediaQuery.of(context)
              //                                 .size
              //                                 .height *
              //                             0.15
              //                         : MediaQuery.of(context)
              //                                 .size
              //                                 .height *
              //                             0.20,
              //                   ),
              //                 ],
              //               )),
              //         ),
              //         ListTile(
              //           leading: Icon(Icons.edit),
              //           title: Text(
              //             'Change URL',
              //             style: TextStyle(
              //                 color: blue,
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: fontsizeSmall),
              //           ),
              //           onTap: () {
              //             Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) => ChangeURLPage(
              //                         weburl: webURL,
              //                         loginurl: loginURL,
              //                         frompage: "login")));
              //           },
              //         ),
              //         Container(
              //             margin: EdgeInsets.only(left: 20, right: 20),
              //             child: Divider(
              //               height: 1,
              //               thickness: 0.5,
              //             )),
              //         ListTile(
              //           leading: Icon(Icons.settings),
              //           title: Text(
              //             'Settings',
              //             style: TextStyle(
              //                 color: blue,
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: fontsizeSmall),
              //           ),
              //           onTap: () {
              //             Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) => SoundSettingsPage(
              //                         frompage: "login")));
              //           },
              //         ),
              //       ],
              //     ),
              //   ),)
            )));
  }

  Future<void> verifyLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? url = prefs.getString("loginurl");
    // var URL;
    // if (url != null) {
    //   URL = encrypter.decrypt(encrypt.Encrypted.fromBase64(url), iv: iv);
    // }
    setState(() {
      isLoading = true;
    });
    //var LoginURL;
    try {
      // if (URL != null) {
      //   LoginURL = URL + loginSuffix;
      // } else {
      //   LoginURL = loginURL + loginSuffix;
      // }

      //print("Login URL combine" + LoginURL);
      var loginrequest = {
        "usercode": _username.text,
        "password": _password.text,
      };
      //print(LoginURL);
      //print(loginrequest);
      var response;
      response = await http
          .post(Uri.parse(loginURL),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(loginrequest))
          .timeout(Duration(seconds: 60));
      var respond = jsonDecode(response.body);
      var res = jsonDecode(respond['d']);
      print(res);
      var userId = res[0]['UserID'];
      var userName = res[0]['UserName'];
      var deptName = res[0]['DepartmentName'];
      var gender = res[0]['Gender'];
      print(userId);

      if (respond != null) {
        setState(() {
          //print("Login Sucess");
          isLoading = false;
          prefs.setString("logout", "0");
          prefs.setString("userID", userId);
          prefs.setString("userName", userName);
          prefs.setString("DeptName", deptName);
          prefs.setString("gender", gender);

          //userinfo = res['d'][0]['Email'];
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
        const snackBar = SnackBar(
          backgroundColor: blue,
          content: Text(
            'Login Successfully',
            style: TextStyle(color: Colors.white),
          ),
        );

        snackbarKey.currentState?.showSnackBar(snackBar);
      } else if (res['d'] == null) {
        setState(() {
          isLoading = false;
        });
        const snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'UserID or password is incorrect',
            style: TextStyle(color: Colors.white),
          ),
        );

        snackbarKey.currentState?.showSnackBar(snackBar);
      } else {
        setState(() {
          isLoading = false;
        });
        const snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Server respond error',
            style: TextStyle(color: Colors.white),
          ),
        );
        snackbarKey.currentState?.showSnackBar(snackBar);
      }
    } on TimeoutException catch (_) {
      // A timeout occurred.
      setState(() {
        isLoading = false;
      });
      const snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Server timeout !!',
          style: TextStyle(color: Colors.white),
        ),
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      const snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Server error !!',
          style: TextStyle(color: Colors.white),
        ),
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }

  Future<void> saveInfo(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var loginrequest = {
        "userID": id,
        "deviceModel": deviceModel,
        "deviceBrand": brand,
        "deviceID": deviceId,
        "firebaseToken": token,
      };
      //print(saveDeviceInfoURL);
      //print(jsonEncode(loginrequest));
      var response;
      response = await http.post(Uri.parse(saveDeviceInfoURL),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(loginrequest));
      var res = jsonDecode(response.body);
      //print(res['code']);
      if (res['code'] == "201") {
        setState(() {
          isLoading = false;
          //print("Save Info Sucess");
          const snackBar = SnackBar(
            backgroundColor: blue,
            content: Text(
              'Saved Successfully',
              style: TextStyle(color: Colors.white),
            ),
          );

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyHomePage()));
        });
      } else {
        setState(() {
          isLoading = false;
        });
        const snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Server error',
            style: TextStyle(color: Colors.white),
          ),
        );
        snackbarKey.currentState?.showSnackBar(snackBar);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      const snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Server error',
          style: TextStyle(color: Colors.white),
        ),
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }
}
