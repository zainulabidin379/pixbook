import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pixbook_wallpapers/screens/viewWallpaper.dart';
import 'package:pixbook_wallpapers/screens/wallpapers.dart';
import 'package:pixbook_wallpapers/shared/constants.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List popularImages = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    fetchapi();
  }

  fetchapi() async {
    await http
        .get(
      Uri.parse(
          'https://api.unsplash.com/search/photos?query=popular&per_page=15&orientation=portrait&client_id=6Nre_M6doOXh59UYhtIFx_gqQHyYRA9Y4MzgHG9q5r0'),
    )
        .then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        popularImages = result['results'];
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: kBgDark,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title:
              Image.asset('assets/images/logo.png', scale: size.width * 0.008),
          centerTitle: true,
          //Menu Button
          leading: Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Image.asset(
                    'assets/images/menu.jpg',
                    color: kGrey,
                    height: 5,
                    width: 5,
                  ),
                ),
              ),
            ),
          ),
          //Theme icon
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 5),
              width: 60,
              child: Icon(
                Icons.search,
                size: 30,
                color: kGrey,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 15, right: 15, bottom: 3),
                child: Text(
                  'Popular',
                  style: TextStyle(
                      fontSize: 20, color: kGrey, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 15),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    height: size.height * 0.25,
                    child: Row(
                      children: [
                        for (var i = 0; i < popularImages.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewWallpaper(
                                              thumbUrl: popularImages[i]['urls']
                                                  ['thumb'],
                                              regularUrl: popularImages[i]
                                                  ['urls']['regular'],
                                                  name: popularImages[i]['user']
                                                  ['name'],
                                                  profileImage: popularImages[i]['user']
                                                  ['profile_image']['medium'],
                                            )));
                              },
                              child: Hero(
                                tag: popularImages[i]['urls']['thumb'],
                                child: Container(
                                  height: size.height * 0.25,
                                  width: 110,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: loading
                                        ? Center(
                                            child: SpinKitCircle(
                                              color: kGrey,
                                              size: 30.0,
                                            ),
                                          )
                                        : Image.network(
                                            popularImages[i]['urls']['thumb'],
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child: SpinKitCircle(
                                                  color: kGrey,
                                                  size: 30.0,
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 15, right: 15, bottom: 3),
                child: Text(
                  'The color tone',
                  style: TextStyle(
                      fontSize: 20, color: kGrey, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 15),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      colorToneCard(Colors.red, 'Red'),
                      colorToneCard(Colors.orange, 'Orange'),
                      colorToneCard(Colors.yellow, 'Yellow'),
                      colorToneCard(Colors.green, 'Green'),
                      colorToneCard(Colors.blue, 'Blue'),
                      colorToneCard(Colors.pink, 'Pink'),
                      colorToneCard(Colors.brown, 'Brown'),
                      colorToneCard(Colors.black, 'Black'),
                      colorToneCard(Colors.grey, 'Gray'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 15, right: 15, bottom: 3),
                child: Text(
                  'Categories',
                  style: TextStyle(
                      fontSize: 20, color: kGrey, fontWeight: FontWeight.w600),
                ),
              ),
              categoriesCard('Abstract', 'abstract', 'Nature', 'nature'),
              categoriesCard('Cars', 'cars', 'Bikes', 'motorcycle'),
              categoriesCard('Animals', 'animals', 'Food', 'food'),
              categoriesCard('Love', 'heart', 'Girly', 'girly'),
              categoriesCard('Music', 'music', 'Beach', 'beach'),
              categoriesCard('Sports', 'sports', 'Technology', 'technology'),
              categoriesCard('Islamic', 'islam', 'Christmas', 'christmas'),
              categoriesCard('Games', 'games', 'Dark', 'dark'),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoriesCard(
      String category1, String image1, String category2, String image2) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: SizedBox(
        height: 80,
        child: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/$image1.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Wallpapers(
                                    category: category1,
                                    image: image1,
                                  )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: kBlack.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(category1,
                            style: TextStyle(
                                fontSize: 17,
                                color: kGrey,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/$image2.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Wallpapers(
                                    category: category2,
                                    image: image2,
                                  )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: kBlack.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(category2,
                            style: TextStyle(
                                fontSize: 17,
                                color: kGrey,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget colorToneCard(Color color, String query) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Wallpapers(
                      category: query,
                      image: query,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
