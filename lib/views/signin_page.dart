import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/auth_services.dart';
import 'package:news_app/views/main_page.dart';
import 'package:news_app/views/signup_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  FirebaseUser firebaseUser;

  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 80,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 150, bottom: 20),
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF57A4FF)),
                    ),
                  ),
                  TextField(
                    onChanged: (text) {
                      setState(() {
                        isEmailValid = EmailValidator.validate(text);
                      });
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Email Address",
                        hintText: "Insert Your Email Address"),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    onChanged: (text) {
                      setState(() {
                        isPasswordValid = text.length >= 6;
                      });
                    },
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Password",
                        hintText: "Insert Your Password",
                          // TODO ADD VISIBILITY BUAT PASSWORD
                          // suffixIcon: Container(
                          //   child: Icon(Icons.eye),
                          // )
                        ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Doesn't have an account yet? ",
                        style: TextStyle(fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.off(SignUpPage());
                        },
                        child: Text(
                          "Get now",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF57A4FF)),
                        ),
                      )
                    ],
                  ),
                  Center(
                    child: Container(
                      width: 150,
                      height: 50,
                      margin: EdgeInsets.only(top: 40, bottom: 30),
                      child:
                          //HARUSNYA PAKAI INI //isSigningIn ? SpinKitFadingCircle(color: Color(0xFF57A4FF),) :
                          RaisedButton(
                        color: isEmailValid && isPasswordValid
                            ? Color(0xFF57A4FF)
                            : Color(0xFFACABB1),
                        shape: StadiumBorder(),
                        child: Text("Sign In",
                            style: TextStyle(
                                color: isEmailValid && isPasswordValid
                                    ? Colors.white
                                    : Colors.grey[200])),
                        onPressed: isEmailValid && isPasswordValid
                            ? () async {
                                // setState(() {
                                //   isSigningIn = true;
                                // });
                                firebaseUser = await AuthServices.signIn(
                                    emailController.text,
                                    passwordController.text);
                                if (firebaseUser == null) {
                                  // setState(() {
                                  //   isSigningIn = false;
                                  // });
                                  // //ALERT DIALOG HERE
                                  // Flushbar(
                                  //   duration: Duration(seconds: 4),
                                  //   flushbarPosition:
                                  //       FlushbarPosition.TOP,
                                  //   backgroundColor: Color(0xFF57A4FF),
                                  //   message: firebaseUser
                                  //       .toString()
                                  //       .split(',')[1]
                                  //       .trim(),
                                  // );
                                } else if (firebaseUser != null) {
                                  Get.to(MainPage(firebaseUser));
                                }
                              }
                            : null,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
