import 'package:flutter/material.dart';
import 'package:health/model/global.dart';
import 'package:health/model/news.dart';
import 'package:health/model/pagination.dart';
import 'package:health/model/profile.dart';
import 'package:health/model/user.dart';
import 'package:health/service/index.dart';
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
  Profile _profile;
  bool check = false;
  bool viewPwd = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<ProfileNotify>(
          builder: (context, ProfileNotify profileNotify, _) =>
              form(context, profileNotify)),
    );
  }

  Widget form(BuildContext context, ProfileNotify profileNotify) {
    _profile = profileNotify.value;
    TextEditingController _userController = new TextEditingController();
    TextEditingController _passwordController = new TextEditingController();
    _userController.text = _profile.lastLoginAcount ?? '';
    _passwordController.text = _profile.lastLoginPassword ?? '';
    check = _profile.isChecked ?? false;
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
                      this.setState(() {
                        this.check = val;
                      });
                      _profile.isChecked = val;
                      _profile.lastLoginAcount = _userController.text;
                      _profile.lastLoginPassword = _passwordController.text;
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

  _login({String loginName, String password}) {
    login(loginName: loginName, password: password).then((res) => {
          if (res != null)
            {
              _profile.isLogin = true,
              _profile.token = res['token'],
              _profile.user = new User.fromJson(res),
              Global.save(),
              getDicts().then((dics) => {
                    _profile.dictionary = dics as List,
                    if (_profile.isChecked)
                      {
                        _profile.lastLoginAcount = loginName,
                        _profile.lastLoginPassword = password,
                      }else{
                        _profile.lastLoginAcount = '',
                        _profile.lastLoginPassword = ''

                      },
                    Global.save(),
                    // Navigator.of(context).pushNamed('/')
                    getNewsList(news: News(),pagination: Pagination(page: 1,rows:3)).then((news)=>{
                      _profile.news = news['list'],
                      Global.save(),
                      Navigator.of(context).pushNamed('/')
                    })
                  })
            }
        });
  }
}
