import 'package:flutter/material.dart';
import 'package:googleapis/docs/v1.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  
  bool isObscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black
          ),
          onPressed: (){},
        ),
        actions: [
          IconButton(
            icon :Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: (){},
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap:(){
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1)
                          )
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            'https://www.dexerto.com/cdn-cgi/image/width=3840,quality=60,format=auto/https://editors.dexerto.com/wp-content/uploads/2023/03/08/Valorant-Gekko-Guide-Graphic.jpg'
                          )
                        )
                        ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      )
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              buildTextField("Full Name", "Demon", false, true),
              buildTextField("Phone number", "Demon", false,true),
              buildTextField("Address", "Demon", false,true),
              buildTextField("Email", "Demon", false,true),
              buildTextField("Password", "****", true, true),
              SizedBox(height: 0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                 
                  ElevatedButton(
                    onPressed: (){}, 
                    child: Text("EDIT"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),

                    ),
                ],
              )

            ],
          ),
        ),
      ),
    );
    
  }
  Widget buildTextField(String labelText, String placeholder, bool isPasswordField,bool readOnly){
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        obscureText: isPasswordField ? isObscurePassword : false,
              readOnly: readOnly,

        decoration: InputDecoration(
          suffixIcon: isPasswordField ?
          IconButton(
            onPressed: (){
              setState(() {
                isObscurePassword = !isObscurePassword;
              });
            },
            icon: Icon(Icons.remove_red_eye, color: Colors.grey,)
          ): null,
          contentPadding: EdgeInsets.only(bottom: 5),
          labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder
      //      hintStyle: TextStyle(
        //      fontSize : 16,
          //    FontWeight : FontWeight.bold,
         //     color: Colors.grey
           // )
        ),
      ),
    );
  }
}

