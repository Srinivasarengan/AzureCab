import 'package:flutter_test/flutter_test.dart';
import 'package:oiitaxi/pages/map/LoginPage.dart';
import 'package:oiitaxi/pages/map/RatingPage.dart';
import 'package:oiitaxi/pages/map/profileUpdate.dart';

void main() {
  group('Login', () {
    test('Empty Email Test', () {
      var result = loginFormValidator.validateEmail('');
      expect(result, 'Please enter an email!');
    });

    test('Invalid Email Test', () {
      var result = loginFormValidator.validateEmail('srinig.com');
      expect(result, 'Please enter a valid email');
    });

    test('Valid Email Test', () {
      var result = loginFormValidator.validateEmail('srini@gmail.com');
      expect(result, null);

    });

    test('Empty Password Test', () {
      var result = loginFormValidator.validatePassword('');
      expect(result, 'Please choose a password.');
    });

    test('Invalid Password Test', () {
      var result = loginFormValidator.validatePassword('sri1');
      expect(result, 'Password must contain atleast 8 characters.');
    });

    test('Valid Password Test', () {
      var result = loginFormValidator.validatePassword('srini12345');
      expect(result, null);
    });
  });


  group('RatingPage', () {
    test('Empty Comment Test', () {
      var result = ratingValidator.validateComment('');
      expect(result, 'Please enter some feedback!');
    });

    test('Valid Comment Test', () {
      var result = ratingValidator.validateComment('It was good!');
      expect(result, null);
    });
  }
  );

  // group('ProfilePage', () {
  //   test('Empty name Test', () {
  //     var result = profileNameValidator.validateName('');
  //     expect(result, 'Please enter some feedback!');
  //   });

  //   test('Valid name Test', () {
  //     var result = profileNameValidator.validateName('Please enter a valid name!');
  //     expect(result, null);
  //   });
  // });


}