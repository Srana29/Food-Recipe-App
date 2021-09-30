import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:myfoodrecipeapp/category.dart';
import 'package:myfoodrecipeapp/model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myfoodrecipeapp/webview.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipeModel> recipeList = <RecipeModel>[];
  List<RecipeModel> recipeListCourosel = <RecipeModel>[];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  List<String> foodBarItem = [
    "Breakfast",
    "Lunch",
    "Dinner",
    "Dessert",
    "Diwali",
    "Navratri",
    "Festivals"
  ];


  getRecipe(String query) async {
    //String url = "https://api.edamam.com/search?q=$query&app_id=c5a75452&app_key=9b574a94112efe6ec2a4387156300e49";
    String url1 = "https://api.edamam.com/api/recipes/v2/?q=$query&app_id=c5a75452&app_key=9b574a94112efe6ec2a4387156300e49&type=public";
    Response response = await get(Uri.parse(url1));
    Map data = jsonDecode(response.body);
    // log(data.toString());
    // print(data);
    setState(() {
      data["hits"].forEach((element) {
        RecipeModel recipeModel = RecipeModel();
        recipeModel = RecipeModel.fromMap(element["recipe"]);
        recipeList.add(recipeModel);
        // log(recipeList.toString());
      });
      setState(() {
        isLoading = false;
      });
    });


    // recipeList.forEach((Recipe) {
    //   print(Recipe.appcalories);
    // });
  }


  getDesserts() async {
   // String url = "https://api.edamam.com/search?q=mithai&app_id=c5a75452&app_key=9b574a94112efe6ec2a4387156300e49";
    String url1 = "https://api.edamam.com/api/recipes/v2/?q=mithai&app_id=c5a75452&app_key=9b574a94112efe6ec2a4387156300e49&type=public";
    Response response = await get(Uri.parse(url1));
    Map data = jsonDecode(response.body);
    // log(data.toString());
    // print(data);
    setState(() {
      data["hits"].forEach((element) {
        RecipeModel recipeModel = RecipeModel();
        recipeModel = RecipeModel.fromMap(element["recipe"]);
        recipeListCourosel.add(recipeModel);
        // log(recipeList.toString());
      });
      setState(() {
        isLoading = false;
      });
    });

    // recipeList.forEach((Recipe) {
    //   print(Recipe.appcalories);
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe("india");
    getDesserts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff213A50), Color(0xff071938)])),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    //Search Wala Container

                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if ((searchController.text).replaceAll(" ", "") ==
                                "") {
                              print("Blank search");
                            } else {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Category(Query: searchController.text)));
                            }
                          },
                          child: Container(
                            child: const Icon(
                              Icons.search,
                              color: Colors.blueAccent,
                            ),
                            margin: const EdgeInsets.fromLTRB(3, 0, 7, 0),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                              if(value.isEmpty){
                                print("Blank Search");
                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Category(Query: value)));
                              }
                            },
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Let's Cook Something!"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: foodBarItem.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> Category(Query: foodBarItem[index])));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: Text(foodBarItem[index],
                                    style: const TextStyle(
                                        fontSize: 19,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          );
                        })),
                isLoading ? Container(height:200,child: Center(child: CircularProgressIndicator())) : Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: CarouselSlider(
                    options: CarouselOptions(
                        height: 200, autoPlay: true, enlargeCenterPage: true),
                    items: recipeListCourosel.map((instance) {
                      return Builder(builder: (BuildContext context) {
                        try{
                          return Container(

                              child : InkWell(
                                onTap: () {
                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>View(instance.appurl)));
                                },
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child : Stack(
                                        children : [
                                          ClipRRect(
                                              borderRadius : BorderRadius.circular(10),
                                              child : Image.network(instance.appimgurl , fit: BoxFit.fill,width: double.infinity,)
                                          ) ,
                                          Positioned(
                                              left: 0,
                                              right: 0,
                                              bottom: 0,
                                              child: Container(

                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    gradient: LinearGradient(
                                                        colors: [
                                                          Colors.black12.withOpacity(0),
                                                          Colors.black
                                                        ],
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter
                                                    )
                                                ),
                                                child : Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 10),
                                                    child:Container( margin: const EdgeInsets.symmetric(horizontal: 10), child: Text(instance.applabel , style: const TextStyle(fontSize: 18 , color: Colors.white , fontWeight: FontWeight.bold),))
                                                ),
                                              )
                                          ),
                                        ]
                                    )
                                ),
                              )
                          );
                        }catch(e){print(e); return Container();}
                      });
                    }).toList(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      // Text(
                      //   "WHAT DO YOU WANT TO COOK TODAY?",
                      //   style: TextStyle(fontSize: 33, color: Colors.white),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(15, 25, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              "Let's Cook Something New!",
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                isLoading ?  Container(height:MediaQuery.of(context).size.height-450,child: Center(child: CircularProgressIndicator())) :  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recipeList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>View(recipeList[index].appurl)));
                        },
                        child: Card(
                          elevation: 0.0,
                          margin: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  recipeList[index].appimgurl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 230,
                                ),
                              ),
                              Positioned(
                                left: 0,
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: const BoxDecoration(
                                      color: Colors.black26),
                                  child: Text(
                                    recipeList[index].applabel,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   right: 0,
                              //   height: 40,
                              //   width: 80,
                              //   child: Container(
                              //       decoration: const BoxDecoration(
                              //         color: Colors.white,
                              //         borderRadius: BorderRadius.only(
                              //           topRight: Radius.circular(10),
                              //           bottomLeft: Radius.circular(10),
                              //         ),
                              //       ),
                              //       child: Center(
                              //           child: Row(
                              //               mainAxisAlignment: MainAxisAlignment.center,
                              //               children: [
                              //                 const Icon(Icons.local_fire_department,size: 17,),
                              //             Text(recipeList[index]
                              //             .appcalories
                              //             .toString()
                              //             .substring(0, 7))
                              //       ]))),
                              // ),

                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
