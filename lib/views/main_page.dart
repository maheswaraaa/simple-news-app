import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/auth_services.dart';
import 'package:news_app/data.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/category_models.dart';
import 'package:news_app/views/article_view.dart';
import 'package:news_app/views/category_news.dart';
import 'package:news_app/views/signin_page.dart';
import 'package:news_app/views/signup_page.dart';

import '../news.dart';

class MainPage extends StatefulWidget {
  final FirebaseUser user;
  MainPage(this.user);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  FirebaseUser firebaseUser;

  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isSigningIn = false;

  int bottomNavBarIndex;
  PageController pageController;

  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> articles = new List<ArticleModel>();

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    bottomNavBarIndex = 0;
    pageController = PageController(initialPage: bottomNavBarIndex);
    categories = getCategories();
    getNews();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
            ),
            SafeArea(child: Container(color: Colors.white)),
            PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  bottomNavBarIndex = index;
                });
              },
              children: <Widget>[
                //HOMEPAGE
                Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Morning",
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "News",
                          style: TextStyle(
                              color: Color(0xFF57A4FF),
                              fontWeight: FontWeight.w600),
                        ),
                        Container(
                            width: 30,
                            height: 30,
                            child:
                                Image.asset("assets/images/morning_news.png")),
                      ],
                    ),
                  ),
                  body:
                      // _loading
                      //     ? Center(
                      //         child: Container(
                      //           child: CircularProgressIndicator(),
                      //         ),
                      //       )
                      //     :
                      SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 70),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          //Categories
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 70,
                            child: ListView.builder(
                                itemCount: categories.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return CategoryTile(
                                    imageUrl: categories[index].imageUrl,
                                    categoryName:
                                        categories[index].categoryName,
                                  );
                                }),
                          ),

                          //Blogs
                          Container(
                            child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                itemCount: articles.length,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return BlogTile(
                                    imageUrl: articles[index].urlToImage,
                                    title: articles[index].title,
                                    desc: articles[index].description,
                                    url: articles[index].url,
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                //PROFILE
                Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Morning",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "News",
                            style: TextStyle(
                                color: Color(0xFF57A4FF),
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                              width: 30,
                              height: 30,
                              child: Image.asset(
                                  "assets/images/morning_news.png")),
                        ],
                      ),
                    ),
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
                                margin: EdgeInsets.only(top: 70, bottom: 20),
                                child: Text(
                                  "Update Your Info",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF57A4FF)),
                                ),
                              ),
                              TextField(
                                onChanged: (text) {
                                  setState(() {
                                    isEmailValid =
                                        EmailValidator.validate(text);
                                  });
                                },
                                controller: emailController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                    onTap: () async {
                                      await AuthServices.signOut();
                                      Get.to(SignUpPage());
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 50,
                                      margin:
                                          EdgeInsets.only(top: 40, bottom: 30),
                                      child:

                                          //HARUSNYA PAKAI INI //isSigningIn ? SpinKitFadingCircle(color: Color(0xFF57A4FF),) :

                                          RaisedButton(
                                        color: isEmailValid && isPasswordValid
                                            ? Color(0xFF57A4FF)
                                            : Color(0xFFACABB1),
                                        shape: StadiumBorder(),
                                        child: Text("Update",
                                            style: TextStyle(
                                                color: isEmailValid &&
                                                        isPasswordValid
                                                    ? Colors.white
                                                    : Colors.grey[200])),
                                        onPressed: isEmailValid &&
                                                isPasswordValid
                                            ? () async {
                                                // setState(() {

                                                //   isSigningIn = true;

                                                // });

                                                firebaseUser =
                                                    await AuthServices.signIn(
                                                        emailController.text,
                                                        passwordController
                                                            .text);

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

                                                } else if (firebaseUser !=
                                                    null) {
                                                  Get.to(
                                                      MainPage(firebaseUser));
                                                }
                                              }
                                            : null,
                                      ),
                                    ),
                                    Container(
                                      width: 150,
                                      height: 50,
                                      margin:
                                          EdgeInsets.only(top: 40, bottom: 30),
                                      child:

                                          //HARUSNYA PAKAI INI //isSigningIn ? SpinKitFadingCircle(color: Color(0xFF57A4FF),) :

                                          RaisedButton(
                                        color: Color(0xFF57A4FF),
                                        shape: StadiumBorder(),
                                        child: Text("Log Out",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        onPressed: () async {
                                          await AuthServices.signOut();
                                          Get.off(SignInPage());
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                    color: Color(0xFF57A4FF),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: BottomNavigationBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white,
                  currentIndex: bottomNavBarIndex,
                  onTap: (index) {
                    setState(() {
                      bottomNavBarIndex = index;
                      pageController.jumpToPage(index);
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                        title: Text(
                          "Home",
                          style: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        icon: Container(
                          margin: EdgeInsets.only(bottom: 6),
                          height: 20,
                          child: bottomNavBarIndex == 0
                              ? Icon(Icons.home)
                              : Icon(Icons.home_outlined),
                        )),
                    BottomNavigationBarItem(
                        title: Text(
                          "My Profile",
                          style: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        icon: Container(
                          margin: EdgeInsets.only(bottom: 6),
                          height: 20,
                          child: bottomNavBarIndex == 1
                              ? Icon(Icons.person)
                              : Icon(Icons.person_outline),
                        )),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class CategoryTile extends StatelessWidget {
  final imageUrl, categoryName;
  CategoryTile({this.imageUrl, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(CategoryNews(
          category: categoryName.toString().toLowerCase(),
        ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 120,
                  height: 60,
                  fit: BoxFit.cover,
                )),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              width: 120,
              height: 60,
              child: Text(
                categoryName,
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url;
  BlogTile(
      {@required this.imageUrl,
      @required this.title,
      @required this.desc,
      @required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ArticleView(
          blogUrl: url,
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(imageUrl)),
            SizedBox(
              height: 8,
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              desc,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
