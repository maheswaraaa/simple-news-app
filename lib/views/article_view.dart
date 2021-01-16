import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatefulWidget {
  final String blogUrl;
  ArticleView({this.blogUrl});

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Morning",
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
            ),
            Text(
              "News",
              style: TextStyle(
                  color: Color(0xFF57A4FF), fontWeight: FontWeight.w600),
            ),
            Container(
                width: 30,
                height: 30,
                child: Image.asset("assets/images/morning_news.png")),
          ],
        ),
        actions: <Widget>[
          Opacity(
            opacity: 0,
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.share),
          ))
        ],
      ),
      body: Container(
        child: WebView(
          initialUrl: widget.blogUrl,
          onWebViewCreated: ((WebViewController webViewController) {
            _completer.complete(webViewController);
          }),
        ),
      ),
    );
  }
}
