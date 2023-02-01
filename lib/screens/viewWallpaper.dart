import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:pixbook_wallpapers/shared/authorProfile.dart';
import 'package:pixbook_wallpapers/shared/constants.dart';
import 'package:pixbook_wallpapers/shared/screenSelectionDialog.dart';

class ViewWallpaper extends StatefulWidget {
  final String thumbUrl;
  final String regularUrl;
  final String name;
  final String profileImage;
  const ViewWallpaper(
      {Key? key,
      required this.thumbUrl,
      required this.regularUrl,
      required this.name,
      required this.profileImage})
      : super(key: key);

  @override
  _ViewWallpaperState createState() => _ViewWallpaperState();
}

class _ViewWallpaperState extends State<ViewWallpaper> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        //Back Button
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              child: Icon(Icons.arrow_back_ios, color: kWhite, size: 27),
            )),
      ),
      body: Stack(
        children: [
          Hero(
            tag: widget.thumbUrl,
            child: Container(
              height: size.height,
              width: size.width,
              child: Image.network(
                widget.regularUrl,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Image.network(
                    widget.thumbUrl,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 35),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(8),
                  height: 60,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    color: kBgDark.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AuthorProfile(username: 'hello',);
                              });
                        },
                        child: Row(children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: kGrey,
                              backgroundImage:
                                  NetworkImage(widget.profileImage),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 120,
                                  child: Text(widget.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: kGrey, fontSize: 13)),
                                ),
                                Text('unsplash.com',
                                    style:
                                        TextStyle(color: kGrey, fontSize: 10))
                              ],
                            ),
                          )
                        ]),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _save(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                    color: kBlack.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Icon(
                                  Icons.file_download_outlined,
                                  size: 25,
                                  color: kGrey,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialogBox();
                                  });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                    color: kBlack.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 25,
                                  color: kGrey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> _selectLocation() async {
    return (await (showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: kBgDark,
            content: SizedBox(
              height: 120,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('HOME SCREEN',
                        style: TextStyle(color: kGrey, fontSize: 15)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('LOCK SCREEN',
                        style: TextStyle(color: kGrey, fontSize: 15)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('BOTH',
                        style: TextStyle(color: kGrey, fontSize: 15)),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {},
                child: Text('Cancel', style: TextStyle(color: kGrey)),
              ),
            ],
          ),
        ))) ??
        false;
  }

  _save() async {
    await _askpermission();
    var response = await Dio().get(widget.regularUrl,
        options: Options(responseType: ResponseType.bytes));
    await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    Fluttertoast.showToast(
      msg: 'Image Downloaded',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: kBgDark,
      textColor: kGrey,
    );
  }

  _askpermission() async {
    if (await Permission.storage.request().isDenied) {
      await Permission.storage.request();
    }
  }
}
