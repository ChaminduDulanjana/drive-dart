import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drivedart/login.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool _verificationSent = false;

  void _register(BuildContext context) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then((UserCredential userCredential) {
      
      User? user = userCredential.user;
      if (user != null) {
        
        String username = _usernameController.text;

        user.updateDisplayName(username).then((_) {
          print("Registration Successful with username: $username");

          
          user.sendEmailVerification().then((_) {
            print('Verification email sent to ${user.email}');
            setState(() {
              _verificationSent = true;
            });
          
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'A verification email has been sent to ${user.email}. Please verify your email to login.',
                ),
              ),
            );
          }).catchError((error) {
            print('Error sending verification email: ${error.toString()}');
            setState(() {
              _verificationSent = false;
            });
          });
        }).catchError((error) {
          print("Error setting username: ${error.toString()}");
         
        });
      }
    }).catchError((error) {
      print("Registration Error: ${error.toString()}");
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(height: kToolbarHeight),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('/Users/chamiyaa/Desktop/drivedart/Img/login.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 300,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: 'User name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: () {
                                _register(context); // Call register function first
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                              ),
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
                                );
                              },
                              child: Text(
                                'Already have an account? Log in',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            // Widget to display verification message
                            if (_verificationSent)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Verification code sent to ${_emailController.text}. After verification click the Login Button above',
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: TextButton(
                          onPressed: null,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(RegisterScreen());
}
