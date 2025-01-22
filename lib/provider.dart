import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import 'home.dart';

class services with ChangeNotifier{
  List myData=[];
  List allList=[];
  fetchDataProvider({required BuildContext context}) async{
var uri=Uri.parse('https://api.nstack.in/v1/todos');
var response=await http.get(uri);
if(response.statusCode==200){
  Map<String,dynamic> json=jsonDecode(response.body);
  myData= json["items"];
  allList=json["items"];
  var filterlist=myData.where((element)=>
  DateFormat.yMMMEd().format(DateTime.parse(element["created_at"]))==
      DateFormat.yMMMEd().format(Jiffy.parse(DateTime.now().toString()).subtract(hours: 2).dateTime)
  ).toList();
  myData=filterlist;
  notifyListeners();
}
else{
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("no internet"),
    backgroundColor: Colors.red,
    )
  );
}
  }
  addData({required BuildContext context,required String title,required String descrption}) async{
    var body={
      "title": "$title",
      "description": "$descrption",
      "is_completed": false
    };
    var uri=Uri.parse("https://api.nstack.in/v1/todos");
    var response=await http.post(uri,
    headers: {'Content-Type': "application/json"},
    body: jsonEncode(body)
    );
    if(response.statusCode==201){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Created"),
            backgroundColor: Colors.green,
          )
      );
      fetchDataProvider(context: context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>home()), (route)=>false);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error"),
            backgroundColor: Colors.red,
          )
      );
    }
  }

  check({required BuildContext context,required var data}) async{
    Map<String,dynamic> body={
      'title': "${data["title"]}",
      'description': "${data["description"]}",
      'is_completed': !data["is_completed"]
    };
    print(jsonEncode(body));
    var uri=Uri.parse('https://api.nstack.in/v1/todos/${data["_id"]}');
    print(uri);
    var response=await http.put(uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body)
    );
    print(response.statusCode);
    if(response.statusCode==200){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("updated"),
            backgroundColor: Colors.green,
          )
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error"),
            backgroundColor: Colors.red,
          )
      );
    }
    fetchDataProvider(context: context);
  }
  update({required BuildContext context,required String title,required String descrption,required bool is_complete,required var id}) async{
    var body={
      "title": "$title",
      "description": "$descrption",
      "is_completed": is_complete
    };
    print(jsonEncode(body));
    var uri=Uri.parse('https://api.nstack.in/v1/todos/$id');
    print(uri);
    var response=await http.put(uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body)
    );
    print(response.statusCode);
    if(response.statusCode==200){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("updated"),
            backgroundColor: Colors.green,
          )
      );
      fetchDataProvider(context: context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>home()), (route)=>false);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error"),
            backgroundColor: Colors.red,
          )
      );
    }
    fetchDataProvider(context: context);
  }
  delete({required BuildContext context,required var data}) async{
    var uri=Uri.parse('https://api.nstack.in/v1/todos/${data["_id"]}');
    var response=await http.delete(uri,
    );
    print(response.statusCode);
    if(response.statusCode==200){
      fetchDataProvider(context: context);}
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error"),
            backgroundColor: Colors.red,
          )
      );
    }
  }
}