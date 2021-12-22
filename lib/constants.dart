import 'package:flutter/material.dart';

const red = Colors.red;
const white = Colors.white;
const black = Colors.black;
const blue = Colors.blue;
const pink = Colors.pink;
const cyan = Colors.cyan;
const green = Colors.green;
const purple = Colors.purple;
const grey = Colors.grey;
const orange = Colors.orange;
const amber = Colors.amber;
const brown = Colors.brown;
const transparent = Colors.transparent;
const ghostWhite = Color(0xfff8f8ff);
const darkBlue = Color(0xFF00325A);

const myDialogTextStyle = TextStyle(
  color: darkBlue,
  fontSize: 18,
  fontStyle: FontStyle.italic,
);

const myAlertTextButtonTextStyle = TextStyle(
  color: red,
  fontSize: 15,
);
final myInputHeadingTextStyle = TextStyle(
  color: pink.shade800,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);
const myHeadingTextStyle = TextStyle(
  fontSize: 20,
  color: pink,
);
const myHintStyle = TextStyle(
  color: Colors.white60,
);
const myTextFormFieldStyle = TextStyle(
  color: white,
);
const myErrorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(14.0)),
  borderSide: BorderSide(
    color: red,
  ),
);
const myFocusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(14.0)),
  borderSide: BorderSide(
    color: white,
  ),
);
const myFocusedErrorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(14.0)),
  borderSide: BorderSide(
    color: red,
  ),
);
const myEnabeledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(14.0)),
  borderSide: BorderSide(
    color: white,
  ),
);
const myUnderlineInputBorder = UnderlineInputBorder(
  borderSide: BorderSide(
    color: white,
  ),
);
myUnderlineInputBorderMethod({required Color color}) {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: color,
    ),
  );
}

const myErrorUnderlineInputBorder = UnderlineInputBorder(
  borderSide: BorderSide(
    color: red,
  ),
);
myErrorUnderlineInputBorderMethod({required Color color}) {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: color,
    ),
  );
}

final List<String> taskCategoryList = [
  'Business',
  'Programming',
  'Information Technology',
  'Human Resources',
  'Marketing',
  'Design',
  'Accounting',
];
final List<String> jobsList = [
  'Manager',
  'Team Leader',
  'Designer',
  'Web designer',
  'Full stack developer',
  'Mobile developer',
  'Marketing',
  'Digital marketing',
];
