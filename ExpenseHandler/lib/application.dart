import 'package:ExpenseHandler/database/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:ExpenseHandler/routes.dart';
import 'package:provider/provider.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<DbProvider>(
      builder: (_) => DbProvider(),
      dispose: (_, value) => value.dispose(),
      child: MaterialApp(
        title: 'Spend Tracker',
        theme: ThemeData(brightness: Brightness.dark),
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}
