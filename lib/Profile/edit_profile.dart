import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// ignore: unused_import
import 'package:googleapis/analytics/v3.dart' as googleapis;
// ignore: unused_import
import 'package:googleapis/docs/v1.dart' as googleapisDoc;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  final String fullName;
  final String phoneNumber;
  final String address;
  final String email;
  final String avatarUrl;
  final String userName;
  final String userID;

  EditProfilePage(
      {required this.fullName,
      required this.phoneNumber,
      required this.address,
      required this.email,
      required this.avatarUrl,
      required this.userName,
      required this.userID});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String token = '';
  bool isObscurePassword = true;
  bool isObscureNewPassword = true;
  bool isObscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.fullName;
    _phoneNumberController.text = widget.phoneNumber;
    _addressController.text = widget.address;
    _emailController.text = widget.email;
    _userNameController.text = widget.userName;
    fetchUserInfo();
  }

  void fetchUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    if (token.isNotEmpty) {
      setState(() {
        token = prefs.getString('token') ?? '';
      });
    }
  }

  void _updateProfile() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.orange.shade600,
          ));
        });
    var requestData = {
      'FullName': _fullNameController.text,
      'PhoneNumber': _phoneNumberController.text,
      'Address': _addressController.text,
      'Avatar': '',
      'UserName': _userNameController.text,
      'Password': _passwordController.text,
      'NewPassword': _newPasswordController.text,
      'ConfirmPassword': _confirmPasswordController.text,
    };
    print(requestData);
    try {
      final response = await http.put(
        Uri.parse(
            'https://ticket-booking-swd392-project.azurewebsites.net/user-management/managed-users/${widget.userID}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        // Parse the user data from the response body// Example value
        Navigator.of(context).pop();
        Fluttertoast.showToast(
          msg: "Cập nhật hồ sơ thành công!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      } else {
        // Handle the error
        Navigator.of(context).pop();
        print('Failed to load user data');
      }
    } catch (error) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: 'Có lỗi xảy ra, vui lòng thử lại sau',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    // Navigate back to profile page after update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Chỉnh sửa thông tin'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
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
                          border: Border.all(width: 4, color: Colors.orange),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(widget.avatarUrl),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              buildTextField("Email", _emailController, false, readOnly: true),
              buildTextField("Tên người dùng", _userNameController, false),
              buildTextField("Tên đầy đủ", _fullNameController, false),
              buildTextField("Số điện thoại", _phoneNumberController, false),
              buildTextField("Địa chỉ", _addressController, false),
              buildTextField("Mật khẩu cũ", _passwordController, false),
              buildTextField("Mật khẩu mới", _newPasswordController, true,
                  isObscure: isObscureNewPassword),
              buildTextField(
                  "Xác nhận mật khẩu", _confirmPasswordController, true,
                  isObscure: isObscureConfirmPassword),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: Row(
                      children: [
                        Text(
                          "Lưu chỉnh sửa",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.save,
                          color: Colors.white,
                        )
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, TextEditingController controller, bool isPasswordField,
      {bool isObscure = false, bool readOnly = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: controller,
        obscureText: isPasswordField ? isObscure : false,
        enabled: !readOnly,
        decoration: InputDecoration(
          suffixIcon: isPasswordField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      if (controller == _newPasswordController) {
                        isObscureNewPassword = !isObscureNewPassword;
                      } else if (controller == _confirmPasswordController) {
                        isObscureConfirmPassword = !isObscureConfirmPassword;
                      } else {
                        isObscurePassword = !isObscurePassword;
                      }
                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ))
              : null,
          contentPadding: EdgeInsets.only(bottom: 5),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
