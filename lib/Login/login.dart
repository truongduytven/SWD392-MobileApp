import 'package:flutter/material.dart';
import 'package:swd392/navigation_menu.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController EmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? errorText;

  void login() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });

    String emailText = EmailController.text;
    String password = passwordController.text;

    try {
      if (emailText.isEmpty) {
        throw ('Email không được để trống');
      }

      if (password.isEmpty) {
        throw ('Mật khẩu không được để trống');
      }

      Response response = await post(
        Uri.parse(
            'https://ticket-booking-swd392-project.azurewebsites.net/auth-management/managed-auths/sign-ins'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': emailText,
          'password': password,
        }),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String accessToken = data['AccessToken'];

        // Verify the token
        Response verifyResponse = await get(
          Uri.parse(
              'https://ticket-booking-swd392-project.azurewebsites.net/auth-management/managed-auths/token-verification'),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        );
        if (verifyResponse.statusCode == 200) {
          var verifyData = jsonDecode(verifyResponse.body);
          if (verifyData['Success'] && verifyData['Result']['RoleName'] == 'Staff') {
            // Save user data to local storage
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('userID', verifyData['Result']['User']['UserID']);
            prefs.setString('token', accessToken);
            prefs.setString(
                'userName', verifyData['Result']['User']['UserName']);
            prefs.setString('email', verifyData['Result']['User']['Email']);

            // Navigate to the homepage
            Navigator.of(context).pop(); // Close the loading dialog
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NavigationMenu();
              }));
            });
            return;
          } else {
            setState(() {
              errorText = 'You are not authorized to access this app';
            });
          }
        } else {
          setState(() {
            errorText = 'Token verification failed';
          });
        }
      } else {
        setState(() {
          errorText = jsonDecode(response.body)['Message'];
        });
      }
    } catch (e) {
      setState(() {
        errorText = 'Error: $e';
      });
    } finally {
      // Dismiss loading indicator regardless of success or failure
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 30),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.orange.shade900,
                Colors.orange.shade600,
                Colors.orange.shade400,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 80),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Đăng nhập",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        "Chào mừng trở lại với The Bus Journey",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 60),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(225, 95, 27, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                child: TextField(
                                  controller: EmailController,
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Mật khẩu',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                        Text(
                          errorText ?? '',
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () => login(),
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.orange.shade900,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Đăng nhập",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.login,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Text(
                          'Tiếp tục với Google',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 40),
                        TextButton(
                          onPressed: () {},
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Google',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.g_mobiledata_rounded,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
