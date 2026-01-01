import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gelir_gider/main.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that login fields are present
    expect(find.text('Kullanıcı Adı'), findsOneWidget); // Hint text
    expect(find.text('Şifre'), findsOneWidget); // Hint text inside TextFormField
    expect(find.text('Giriş Yap'), findsOneWidget); // Button text
    expect(find.text('Hesap Oluştur!'), findsOneWidget); // Button text
  });
}
