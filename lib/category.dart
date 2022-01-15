import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:myfoodrecipeapp/model.dart';
import 'package:myfoodrecipeapp/webview.dart';


class Category extends StatefulWidget {

  String Query;
  Category({required this.Query});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

  bool isLoading = true;

  List<RecipeModel> recipeModelList = <RecipeModel>[];

  getNewsByQuery(String query) async {
    String url="";

    if(query=="Breakfast"){
      url = "https://api.edamam.com/api/recipes/v2/?q=breakfast&app_id=app_id&app_key=9b574a94112efe6ec2a4387156300e49&type=public";

    }else if(query=="Lunch"){
      url="https://api.edamam.com/api/recipes/v2/?q=lunch&app_id=app_id&app_key=app_key&type=public&cuisineType=Indian&health=vegetarian";
    }else  if (query=="Dinner"){
      url = "https://api.edamam.com/api/recipes/v2/?q=dinner&app_id=app_id&app_key=app_key&type=public&cuisineType=Indian&health=vegetarian";
    }else if(query=="Diwali"){
      url="https://api.edamam.com/api/recipes/v2/?q=diwali&app_id=app_id&app_key=app_key&type=public&cuisineType=Indian&health=vegetarian";
    } else if(query=="Dessert"){
      url="https://api.edamam.com/api/recipes/v2/?q=dessert&app_id=app_id&app_key=app_key&type=public&cuisineType=Indian&health=vegetarian";
    }else if(query=="Festivals"){
      url="https://api.edamam.com/api/recipes/v2/?q=festivals&app_id=app_id&app_key=app_key&type=public&cuisineType=Indian&health=vegetarian";
    }else if(query=="Navratri"){
      url="https://api.edamam.com/api/recipes/v2/?q=navratri&app_id=app_id&app_key=app_key&type=public&cuisineType=Indian";
    }else{
      url="https://api.edamam.com/api/recipes/v2/?q=$query&app_id=app_id&app_key=app_key&type=public";
    }


    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    // log(data.toString());
    // print(data);
    setState(() {
      data["hits"].forEach((element) {
        try {
          RecipeModel recipeModel = RecipeModel();
          recipeModel = RecipeModel.fromMap(element["recipe"]);
          recipeModelList.add(recipeModel);
          // log(recipeList.toString());
          setState(() {
            isLoading = false;
          });
        } catch (e) {
          print(e);
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery(widget.Query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YUMMY YUMMY"),
        centerTitle: true,
      ),
      body:  SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                margin : EdgeInsets.fromLTRB(15, 25, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 12,),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: Text(widget.Query, style: TextStyle(  fontSize: 39
                      ),),
                    ),
                  ],
                ),
              ),
              isLoading ?  Container(height:MediaQuery.of(context).size.height-450,child: Center(child: CircularProgressIndicator())) :
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: recipeModelList.length,
                  itemBuilder: (context, index) {
                    try{
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>View(recipeModelList[index].appurl)));
                          },
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 1.0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(recipeModelList[index].appimgurl ,fit: BoxFit.fill, height: 230,width: double.infinity, )),

                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(

                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.black12.withOpacity(0),
                                                    Colors.black
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter
                                              )
                                          ),
                                          padding: EdgeInsets.fromLTRB(15, 15, 10, 8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                recipeModelList[index].applabel,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              //Text(recipeModelList[index].newsDes.length > 50 ? "${recipeModelList[index].newsDes.substring(0,50)}...." : recipeModelList[index].newsDes , style: TextStyle(color: Colors.white , fontSize: 12))
                                            ],
                                          )))
                                ],
                              )),
                        ),
                      );
                    }catch(e){print(e); return Container();}
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
