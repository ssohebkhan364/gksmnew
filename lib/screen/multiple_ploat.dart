
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
var selectedIndexes = [];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
  appBar: AppBar(
          title: Text(
            "Multiple Schems",
          ),
          backgroundColor:   Color(
                                                  0xff014E78),
        ),

   body:Column(
    children: [
 Expanded(
   child: GridView.count(
                      crossAxisCount: 4,
       children: List.generate(30, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                               shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
   
  ),
                              elevation: 10,
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),   color: Color(
                                                    0xfff6f5fb),),
                             
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                 Wrap(
                                direction: Axis.vertical,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: -15,
                                children: [
                                  Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Color(0xff014E78),
                                    cardColor: Color(0xff014E78)
                                  ),
                                              child:          SizedBox(
                                                height: 50
                                                ,
                                                width: 50,
                                                child: Checkbox(
                                  
                                        value: selectedIndexes.contains(index),
                                        onChanged: ( value) {
                                          print("jjjj");
                                          print(value);
                                          print(selectedIndexes);
                                          if(selectedIndexes.contains(index)) {
                                             selectedIndexes.remove(index); 
                                          } else {
                                            selectedIndexes.add(index); 
                                          }
                                          setState(() {});
                                        },
                                        checkColor: Colors.greenAccent,
                                        activeColor: Colors.black,
                                     
                                      ),
                                              )),
                                           
                                    Text(
                                      "TJ10",
                                      
                                      style: TextStyle(fontSize: 12.0,color: Color(0xff014E78)),
                                    ),
                                    SizedBox(height: 30,)
                                  ],
                                ),
                                                ])  ),
                            ),
                          );
                        },
       )
         ),
 ),
SizedBox(height: 10,),
 Padding(
   padding: const EdgeInsets.all(8.0),
   child: Container(
                          height: 52,
                          decoration: const BoxDecoration(
                              color: Color(
                                                  0xff014E78),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: const Center(
                            child: Text(
                              "Submit ",
                              style: TextStyle(
                                  color: Colors.white,
                             fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
 ),
                
SizedBox(height: 10,)
   ]) );

  }}
