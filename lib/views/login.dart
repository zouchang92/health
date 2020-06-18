import 'package:flutter/material.dart';
import 'package:health/model/global.dart';

import 'package:health/model/pagination.dart';
import 'package:health/model/profile.dart';
import 'package:health/model/user.dart';
import 'package:health/service/index.dart';

import 'package:health/styles/loginStyle.dart';
import 'package:health/value/loginValue.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  Profile _profile = Global.profile;
  bool check = false;
  bool viewPwd = true;
  TextEditingController _userController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    if (_profile.isChecked) {
      _userController.text = _profile.lastLoginAcount ?? '';
      _passwordController.text = _profile.lastLoginPassword ?? '';
      check = _profile.isChecked ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: form());
  }

  Widget form() {
    return Form(
      key: _formKey,
      autovalidate: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(child: Image.asset('images/appIcon.png')),
            // Image.asset('images/appIcon.png'),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: LoginStyle.containerHorizontal),
              child: TextFormField(
                controller: _userController,
                autofocus: false,
                decoration: new InputDecoration(
                    hintText: LoginValue.userTextFormhintText,
                    prefixIcon: Icon(Icons.person)),
                validator: (String value) {
                  if (value == null || value.isEmpty) {
                    return LoginValue.emptyTextTip;
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: LoginStyle.containerHorizontal),
              child: TextFormField(
                autofocus: false,
                controller: _passwordController,
                obscureText: viewPwd,
                decoration: new InputDecoration(
                    hintText: LoginValue.passwordTextFormhintText,
                    prefixIcon: Icon(Icons.lock)),
                validator: (String value) {
                  if (value == null || value.isEmpty) {
                    return LoginValue.pwdEmptyTextTip;
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: LoginStyle.containerHorizontal),
              child: Row(children: <Widget>[
                Checkbox(
                    value: this.check,
                    onChanged: (bool val) {
                      // this.check = val;
                      // print('check:$val');
                      this.setState(() {
                        this.check = val;
                      });
                      _profile.isChecked = val;

                      // Global.save();
                    }),
                Text(LoginValue.checkBoxText)
              ]),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: LoginStyle.loginButtonVertical,
                  horizontal: LoginStyle.containerHorizontal),
              child: RaisedButton(
                onPressed: () {
                  _formSubmit(
                      loginName: _userController.text,
                      password: _passwordController.text);
                },
                child: Row(
                    children: <Widget>[Text(LoginValue.submitText)],
                    mainAxisAlignment: MainAxisAlignment.center),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _formSubmit({String loginName, String password}) {
    var _form = _formKey.currentState;
    if (_form.validate()) {
      // print('$loginName,$password');
      _login(loginName: loginName, password: password);
    }
  }

  _login({String loginName, String password}) async {
    if (check) {
      _profile.isChecked = check;
      _profile.lastLoginAcount = loginName;
      _profile.lastLoginPassword = password;
    } else {
      _profile.isChecked = false;
      _profile.lastLoginAcount = '';
      _profile.lastLoginPassword = '';
    }
    Global.save();
    var res = await login(loginName: loginName, password: password);
    print('loginRes:$res');

    if (res != null) {
      _profile.token = res['token'];

      _profile.user = User.fromJson(res);
      var dics = await getDicts();
      if (dics != null) {
        _profile.dictionary = dics;
        var newsList =
            await getNewsList(pagination: Pagination(page: 1, rows: 3));
        if (newsList != null) {
          _profile.isLogin = true;
          Navigator.of(context).pushNamed('/');
        }
      }
    }
  }
}
