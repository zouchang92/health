import 'package:flutter/material.dart';
import 'package:health/model/profile.dart';
import 'package:health/store/profileNotify.dart';
import 'package:health/styles/loginStyle.dart';
import 'package:health/value/loginValue.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool check = false;
  bool viewPwd = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<ProfileNotify>(builder: (context,ProfileNotify profileNotify,_)=>
        form(context,profileNotify)
      ),
    );
  }
  Widget form(BuildContext context,ProfileNotify profileNotify){
    Profile _profile = profileNotify.value;
    TextEditingController _userController = new TextEditingController();
    TextEditingController _passwordController = new TextEditingController();
    _userController.text = _profile.lastLoginAcount??'';
    _passwordController.text = _profile.lastLoginPassword??'';
   check = _profile.isChecked??false;
   return Form(
     key: _formKey,
     autovalidate: true,
     child: Scaffold(
        body: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/appIcon.png'),  
            Padding(
              padding:EdgeInsets.symmetric(horizontal:LoginStyle.containerHorizontal) ,
              child: TextFormField(
                controller:_userController,
                decoration: new InputDecoration(
                  hintText:LoginValue.userTextFormhintText,
                  prefixIcon:Icon(Icons.person)
                ),
                validator: (String value){
                  if(value == null || value.isEmpty){
                    return LoginValue.emptyTextTip;
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:LoginStyle.containerHorizontal),
              child: TextFormField(
                controller:_passwordController,
                obscureText:viewPwd,
                decoration: new InputDecoration(
                  hintText:LoginValue.passwordTextFormhintText,
                  prefixIcon:Icon(Icons.lock)
                ),
                validator: (String value){
                  if(value == null || value.isEmpty){
                    return LoginValue.pwdEmptyTextTip;
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:LoginStyle.containerHorizontal),
              child: Row(children: <Widget>[
                Checkbox(
                  value: this.check, 
                  onChanged: (bool val){
                    this.check = val;
                    _profile.isChecked = val;
                    _profile.lastLoginAcount = _userController.text;
                    _profile.lastLoginPassword = _passwordController.text;
                    // Global.save();
                  }
                ),
                Text(LoginValue.checkBoxText)
              ]),
            ),
            Padding(padding: EdgeInsets.symmetric(
              vertical:LoginStyle.loginButtonVertical,
              horizontal: LoginStyle.containerHorizontal
            ),
            child: RaisedButton(
              onPressed: (){
                  //+接口
                  _profile.isLogin = true;
                  Navigator.of(context).pushNamed('/home');
              },
              child: Row(children: <Widget>[
                Text(LoginValue.submitText)
              ],mainAxisAlignment: MainAxisAlignment.center),
            ),
            )
          ],
        ),
     ),
    );
  }
}