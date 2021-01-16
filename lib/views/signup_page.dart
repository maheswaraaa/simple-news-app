import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/auth_services.dart';
import 'package:news_app/views/signin_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  FirebaseUser firebaseUser;

  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isSigningUp = false;

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
                      "Sign Up",
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
                        hintText: "Insert Your Password"),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Already have an account? ",
                        style: TextStyle(fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(SignInPage());
                        },
                        child: Text(
                          "Sign in",
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
                          //HARUSNYA PAKAI INI //isSigningUp ? SpinKitFadingCircle(color: Color(0xFF57A4FF),) :
                          RaisedButton(
                        color: isEmailValid && isPasswordValid
                            ? Color(0xFF57A4FF)
                            : Color(0xFFACABB1),
                        shape: StadiumBorder(),
                        child: Text("Sign Up",
                            style: TextStyle(
                                color: isEmailValid && isPasswordValid
                                    ? Colors.white
                                    : Colors.grey[200])),
                        onPressed: isEmailValid && isPasswordValid
                            ? () async {
                                // setState(() {
                                //   isSigningUp = true;
                                // });
                                firebaseUser = await AuthServices.signIn(
                                    emailController.text,
                                    passwordController.text);
                                if (firebaseUser == null) {
                                  // setState(() {
                                  //   isSigningUp = false;
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
                                  Get.to(SignInPage());
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
