import 'package:flutter/material.dart';

double getMediaQueryHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getMediaQueryWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
