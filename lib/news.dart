import 'dart:convert';

import 'models/article_model.dart';
import 'package:http/http.dart' as http;

class News {
  List<ArticleModel> news = [];

  Future<void> getNews() async {
    String url =
        "http://newsapi.org/v2/top-headlines?country=id&category=business&apiKey=5e02c4b57ec34ea6950003945ec4be69";

    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == "ok"){
      jsonData["articles"].forEach((element){

        if(element["urlToImage"] != null && element["description"] != null){
          
          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            content: element['content'],
          );

          news.add(articleModel);

        }

      });
    }
  }
}

class FetchCategoryNews {
  List<ArticleModel> news = [];

  Future<void> getCategoryNews(String category) async {
    String url =
        "http://newsapi.org/v2/top-headlines?country=id&category=$category&apiKey=5e02c4b57ec34ea6950003945ec4be69";

    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == "ok"){
      jsonData["articles"].forEach((element){

        if(element["urlToImage"] != null && element["description"] != null){
          
          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            content: element['content'],
          );

          news.add(articleModel);

        }

      });
    }
  }
}
