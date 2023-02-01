import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixbook_wallpapers/shared/constants.dart';
import 'package:http/http.dart' as http;

class Wallpapers extends StatefulWidget {
  final String category;
  final String image;
  const Wallpapers({Key? key, required this.category, required this.image})
      : super(key: key);

  @override
  _WallpapersState createState() => _WallpapersState();
}

class _WallpapersState extends State<Wallpapers> {
  List images = [];
  int page = 1;
  bool loading = true;
  bool loadMore = false;

  @override
  void initState() {
    super.initState();
    fetchapi();
  }

  fetchapi() async {
    await http
        .get(
      Uri.parse(
          'https://api.unsplash.com/search/photos?query=${widget.image}&per_page=29&orientation=portrait&client_id=6Nre_M6doOXh59UYhtIFx_gqQHyYRA9Y4MzgHG9q5r0'),
    )
        .then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['results'];
        loading = false;
      });
    });
  }

  loadmore() async {
    setState(() {
      page = page + 1;
      loadMore = true;
    });
    await http
        .get(Uri.parse(
            'https://api.unsplash.com/search/photos?page=$page&query=${widget.image}&per_page=29&orientation=portrait&client_id=6Nre_M6doOXh59UYhtIFx_gqQHyYRA9Y4MzgHG9q5r0'))
        .then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['results']);
        loadMore = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.category,
          style: TextStyle(color: kGrey, fontSize: 35),
        ),
        titleSpacing: 0,
        //Back Button
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              child: Icon(Icons.arrow_back_ios, color: kGrey, size: 27),
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              StaggeredGridView.countBuilder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                crossAxisCount: 4,
                itemCount: loading ? 11 : images.length,
                itemBuilder: (context, index) {
                  return loading
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Container(
                            color: kBlack.withOpacity(0.2),
                            child: Center(
                              child: SpinKitCircle(
                                color: kGrey.withOpacity(0.5),
                                size: 30.0,
                              ),
                            ),
                          ))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(
                            images[index]['urls']['small'],
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Container(
                                    color: kBlack.withOpacity(0.2),
                                    child: Center(
                                      child: SpinKitCircle(
                                        color: kGrey.withOpacity(0.5),
                                        size: 30.0,
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        );
                },
                staggeredTileBuilder: (index) =>
                    StaggeredTile.count(2, index.isOdd ? 3.5 : 3),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              GestureDetector(
                onTap: () {
                  loadmore();
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Center(
                    child: Container(
                      height: 50,
                      width: size.width * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      child: loadMore
                          ? Center(
                              child: SpinKitCircle(
                                color: kGrey,
                                size: 30.0,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.refresh,
                                  color: kGrey,
                                ),
                                Text('  Load More',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: kGrey,
                                    )),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
