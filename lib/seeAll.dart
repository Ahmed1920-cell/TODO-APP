import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider.dart';

import 'create.dart';

class seeAll extends StatelessWidget {
  const seeAll({super.key});

  @override
  Widget build(BuildContext context) {
    var pro=Provider.of<services>(context);
    var myData=pro.allList;
    var myData_reverse=myData.reversed.toList();
    GlobalKey<ScaffoldState> _key=GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _key,
      backgroundColor: Colors.black12,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: (){
          _key.currentState!.showBottomSheet((context)=>create());
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        centerTitle: true,
        title: Text("All Tasks"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 15,),

            Expanded(
              child: ListView.builder(
                  itemCount: myData.length,
                  itemBuilder: (context,index){

                    var data=myData_reverse[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Color(0xff081173), width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 15,
                        shadowColor: Colors.blue,
                        color: Colors.black,
                        child:Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data["title"].toString().toUpperCase(),style: TextStyle(fontSize: 24,decoration: data["is_completed"]?TextDecoration.lineThrough:null, decorationColor: Colors.orange, decorationThickness: 2.0),),
                              SizedBox(height: 10,),
                              Text(data["description"],style: TextStyle(fontSize: 17),),
                              SizedBox(height: 10,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(DateFormat.yMMMEd().format(Jiffy.parse(data["created_at"]).add(hours: 2).dateTime).toString(),
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                      onTap: (){
                                        _key.currentState!.showBottomSheet((context)=>create(data: data,));
                                      }, child: Icon(Icons.edit,color: Color(0xff081173),)),
                                  SizedBox(width: 15,),
                                  GestureDetector(
                                      onTap: (){
                                        showDialog(context: context, builder: (context)=>
                                            AlertDialog(
                                              backgroundColor: Colors.black,
                                              icon: Icon(Icons.warning,color: Colors.red,size: 30,),
                                              title: Text("Alert"),
                                              content: Text("Are you Sure?"),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: (){
                                                          pro.delete(context: context, data: data);
                                                          Navigator.of(context).pop();
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.red
                                                        )
                                                        , child: Text("Yes",style: TextStyle(color: Colors.white),)),
                                                    SizedBox(width: 30,),
                                                    ElevatedButton(onPressed: (){
                                                      Navigator.of(context).pop();
                                                    },style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.grey
                                                    ), child: Text("No",style: TextStyle(color: Colors.white))),

                                                  ],
                                                ),
                                              ],
                                            )
                                        );
                                      }, child: Icon(Icons.delete,color: Colors.red,)),
                                  SizedBox(width: 15,),
                                  SizedBox(
                                    width: 24.0,
                                    height: 24,
                                    child: Checkbox(
                                        activeColor: Colors.green,
                                        shape: CircleBorder(),
                                        value: data["is_completed"], onChanged: (_){
                                      pro.check(context: context, data: data);
                                    }),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

              ),
            )
          ],
        ),
      ),
    );
  }
}
