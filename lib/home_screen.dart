import 'package:flutter/material.dart';
import 'package:sqlite_example01/database/connect_db.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('DB Connect. Example 2023 / 5 / 11'),
      ),
    );
  }
}