import 'dart:io';

import 'package:flutter/material.dart';

Widget showUserImg(String? userImage) {
  const defaultImg = 'assets/images/avatar.png';

  ImageProvider? provider;
  final uri = Uri.parse(userImage ?? defaultImg);

  if (uri.path.contains(defaultImg)) {
    provider = AssetImage(uri.toString());
  } else if (uri.scheme.contains('http')) {
    provider = NetworkImage(uri.toString());
  } else {
    provider = FileImage(File(uri.toString()));
  }

  return CircleAvatar(
    backgroundImage: provider,
    radius: 18,
  );
}
