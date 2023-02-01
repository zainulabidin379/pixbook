import 'package:flutter/material.dart';
import 'package:pixbook_wallpapers/shared/constants.dart';

class CustomDialogBox extends StatefulWidget {
  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
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
              EdgeInsets.only(left: 16, top: 25 + 16, right: 16, bottom: 16),
          margin: EdgeInsets.only(top: 25),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: kBgDark,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('HOME SCREEN',
                    style: TextStyle(color: kGrey, fontSize: 17)),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('LOCK SCREEN',
                    style: TextStyle(color: kGrey, fontSize: 17)),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text('BOTH', style: TextStyle(color: kGrey, fontSize: 15)),
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
                      'Cancel',
                      style: TextStyle(fontSize: 15, color: kGrey.withOpacity(0.5)),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
