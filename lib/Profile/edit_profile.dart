import 'package:flutter/material.dart';
import 'package:googleapis/docs/v1.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  bool isObscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
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
                            'https://cdn-media.sforum.vn/storage/app/media/wp-content/uploads/2023/03/valorant-gekko-4.jpg'
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
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Colors.white
                          ),
                          color: Colors.orange
                        ),
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
              buildTextField("Full Name", "Demon", false),
              buildTextField("Phone number", "Demon", false),
              buildTextField("Address", "Demon", false),
              buildTextField("Email", "Demon", false),
              buildTextField("Password", "****", true),
              SizedBox(height: 0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    onPressed: (){},
                    child: Text("CANCEL"),
                    style:OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){}, 
                    child: Text("SAVE"),
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
  Widget buildTextField(String labelText, String placeholder, bool isPasswordField){
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        obscureText: isPasswordField ? isObscurePassword : false,
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

