import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/create.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_)=>services(),
    child:MyTodo(),
  ));
}
class MyTodo extends StatelessWidget {
  const MyTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
        primaryColor: Colors.black,
          appBarTheme:AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            color: Colors.black,
              titleTextStyle:TextStyle(color: Colors.white,fontSize: 22)
          ) ,
          textTheme: Theme.of(context).textTheme.apply(bodyColor:Colors.white ),

      ),
      home: home(),
    );
  }
}

