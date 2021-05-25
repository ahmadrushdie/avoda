import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatefulWidget {
  CustomNetworkImage({
    Key key,
    @required this.imageUrl,
    this.avatarPath,
    this.width,
    this.hieght,
    this.isCircular = false,
    this.raduis = 0,
  }) : super(key: key);

  String imageUrl;
  bool isCircular = false;
  String avatarPath;
  double width;
  double hieght;
  double raduis = 1;
  @override
  _NetworkImageState createState() => _NetworkImageState();
}

class _NetworkImageState extends State<CustomNetworkImage> {
  set imageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl == null) {
      widget.imageUrl = "https://cdn-a.william-reed.com/var/";
    }

    return ClipRRect(
        borderRadius: BorderRadius.circular(widget.isCircular
            ? widget.width / 2
            : widget.raduis > 0
                ? widget.raduis
                : 0),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          width: widget.width,
          height: widget.hieght,
          imageUrl: widget.imageUrl,
          placeholder: (context, url) =>
              Image(image: AssetImage('assets/images/avatar.png')),
          errorWidget: (context, url, error) =>
              Image(image: AssetImage('assets/images/avatar.png')),
        ));
  }
}
