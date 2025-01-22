import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/create.dart';
import 'package:todo_app/provider.dart';
import 'package:todo_app/seeAll.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<services>(context,listen: false).fetchDataProvider(context: context);
  }
  bool data_empty=false;
  bool sheet=false;
  Widget build(BuildContext context) {
    var pro=Provider.of<services>(context);
    List myData=pro.myData;
    var myData_reverse=myData.reversed.toList();
    if(myData.isEmpty){
      data_empty=true;
    }
GlobalKey<ScaffoldState> _key=GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _key,
      backgroundColor: Colors.black12,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: (){
          if(!sheet){
            sheet=!sheet;
          _key.currentState!.showBottomSheet((context)=>create());}
          else{
            sheet=!sheet;
            Navigator.of(context).pop();
          }
        },
      child: Icon(Icons.add),
      ),
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        centerTitle: true,
        title: Column(
          children: [
            Text("Welcome"),
            Text("Ahmed Mohamed"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.orange
                    ),
                    child: Text((DateFormat.yMMMEd().format(DateTime.now()).toString()),
                      style: TextStyle(fontSize: 18),
                  )
                  ),
                ),
              IconButton(onPressed: (){
                pro.fetchDataProvider(context: context);
              }, icon: Icon(Icons.refresh,color: Colors.white,))
              ],
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Today tasks",style: TextStyle(fontSize: 20),),
              ],
            ),
            Row(
              children: [
                Spacer(),
                ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                  seeAll()
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue
                )
                , child: Text("See all",style: TextStyle(color: Colors.white),)),
              ],
            ),
            Expanded(
              child: data_empty?Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No Tasks Today",
                  style: TextStyle(fontSize: 22),),
                ],
              ):
              ListView.builder(
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
