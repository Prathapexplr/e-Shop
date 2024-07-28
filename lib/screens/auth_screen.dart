import 'package:eshop/constants/color.dart';
import 'package:eshop/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _name = '';
  bool _isLogin = true;

  void _trySubmit() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid != null && isValid) {
      _formKey.currentState?.save();

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final navigator = Navigator.of(context);

      try {
        if (_isLogin) {
          await authProvider.login(_email, _password);
        } else {
          await authProvider.signUp(_name, _email, _password);
        }

        if (mounted) {
          navigator.pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(child: Text('Authentication failed')),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: CustomColors.lightGrey,
      appBar: AppBar(
          backgroundColor: CustomColors.lightGrey,
          leadingWidth: 100,
          leading: Row(
            children: [
              SizedBox(
                width: width / 15,
              ),
              Text(
                "e-Shop",
                style: GoogleFonts.poppins(
                    color: CustomColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ],
          )),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: height / 5),
                  Visibility(
                    visible: !_isLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: TextFormField(
                        key: const ValueKey('name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your good name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: "Name",
                          hintStyle: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 94, 93, 93),
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          border: InputBorder.none,
                        ),
                        onSaved: (value) {
                          _name = value!;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 50,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextFormField(
                      key: const ValueKey('email'),
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: GoogleFonts.poppins(
                            color: const Color.fromARGB(255, 94, 93, 93),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        border: InputBorder.none,
                      ),
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                  ),
                  SizedBox(
                    height: height / 50,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextFormField(
                      key: const ValueKey('password'),
                      validator: (value) {
                        if (value == null || value.length < 7) {
                          return 'Password must be at least 7 characters long';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: GoogleFonts.poppins(
                            color: const Color.fromARGB(255, 94, 93, 93),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        border: InputBorder.none,
                      ),
                      obscureText: true,
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                  ),
                  SizedBox(height: _isLogin ? height / 3.25 : height / 4),
                  SizedBox(
                    width: width / 1.8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: CustomColors.primaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextButton(
                        onPressed: _trySubmit,
                        child: Center(
                          child: Text(
                            _isLogin ? 'Login' : 'Signup',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLogin ? 'New here ? ' : 'Already have an account ? ',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: const Color.fromARGB(255, 83, 82, 82)),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                          _isLogin ? 'Signup' : 'Login',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              color: CustomColors.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
