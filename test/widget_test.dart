// // // This is a basic Flutter widget test.
// // //
// // // To perform an interaction with a widget in your test, use the WidgetTester
// // // utility that Flutter provides. For example, you can send tap and scroll
// // // gestures. You can also use WidgetTester to find child widgets in the widget
// // // tree, read text, and verify that the values of widget properties are correct.
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter_test/flutter_test.dart';
// // import 'package:oiitaxi/main.dart';
// // import 'package:oiitaxi/pages/map/HomePage.dart';
// //
// // import 'package:oiitaxi/pages/map/LoginPage.dart';
// //
// // void main() {
// //   Widget makeTestableWidget({required Widget child}){
// //     return MaterialApp(
// //       home: child,
// //     );
// //   }
// //   group('Testing',(){
// //     testWidgets('Testing the home', (WidgetTester tester) async{
// //       final String title = 'Cab Hiring';
// //       await tester.pumpWidget(makeTestableWidget(child:MyApp()));
// //       final titleFinder = find.text(title);
// //       expect(titleFinder,findsOneWidget);
// //     });
// //   });
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:oiitaxi/main.dart';
// import 'package:oiitaxi/pages/map/pickUpAndDropLocation.dart';

// void main() {
//   testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
//     await tester.pumpWidget(const ChooseLoc(uid: '211wqs3', isDriver: true));
//     final titleFinder = find.text('211wqs3');
//     // final messageFinder = find.;

//     // Use the `findsOneWidget` matcher provided by flutter_test to verify
//     // that the Text widgets appear exactly once in the widget tree.
//     expect(titleFinder, findsOneWidget);
//     // expect(messageFinder, findsOneWidget);
//   });
// }