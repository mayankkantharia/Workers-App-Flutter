import 'package:flutter/material.dart';

navigateWithReplacement(BuildContext context, dynamic destination) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => destination,
    ),
  );
}

navigateWithoutReplacement(BuildContext context, dynamic destination) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => destination,
    ),
  );
}
