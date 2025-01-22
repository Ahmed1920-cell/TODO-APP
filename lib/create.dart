import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/provider.dart';

class create extends StatefulWidget {
  create({this.data});
Map? data;
  @override
  State<create> createState() => _createState();
}

class _createState extends State<create> {
  @override
  var title=TextEditingController();
  var description=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool update=false;
  String? valid(String? value){
    if (value == null || value.isEmpty) {
      return 'Please enter data';
    }
    return null;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.data!=null){
      update=true;
      title.text=widget.data!["title"];
      description.text=widget.data!["description"];
    }
  }
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/2+51,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.orange,width: 4)),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
          color: Colors.black,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
           // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text("Title".toUpperCase(),style: TextStyle(fontSize: 20),),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  hintText: "Enter the title",
                ),
                controller: title,
                keyboardType: TextInputType.text,
                validator: valid,
              ),
              SizedBox(
                height: 20,
              ),
              Text("description".toUpperCase(),style: TextStyle(fontSize: 20),),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  hintText: "Enter the description",
      
                ),
                //minLines: ,
                maxLines: 6,
                controller: description,
                keyboardType: TextInputType.text,
                validator: valid,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange
                        ),
                        onPressed: (){
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, proceed further
                            !update?Provider.of<services>(context,listen: false).addData(context: context, title: title.text, descrption: description.text):
                            Provider.of<services>(context,listen: false).update(context: context, title: title.text, descrption: description.text, is_complete: widget.data!["is_completed"], id: widget.data!["_id"])
                            ;
                          
                            // Add login logic here
                          }
                          
                          
                          
                        }, child: Text(update?"update":"Add",style: TextStyle(color: Colors.black))),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}
