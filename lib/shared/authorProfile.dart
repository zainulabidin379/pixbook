import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthorProfile extends StatefulWidget {
  final String username;

  const AuthorProfile({Key? key, required this.username}) : super(key: key);

  @override
  _AuthorProfileState createState() => _AuthorProfileState();
}

class _AuthorProfileState extends State<AuthorProfile> {
   List user=[];
   bool loading = true;
    fetchapi() async {
    await http
        .get(
      Uri.parse(
          'https://api.unsplash.com/users/${widget.username}&client_id=6Nre_M6doOXh59UYhtIFx_gqQHyYRA9Y4MzgHG9q5r0'),
    )
        .then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        user = result['results'];
        loading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding:
              EdgeInsets.only(left: 16, top: 16 + 20, right: 16, bottom: 16),
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'widget.title',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'widget.descriptions',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'widget.text',
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 45,
              backgroundImage: AssetImage("assets/images/cars.jpg")),
        ),
      ],
    );
  }
}
