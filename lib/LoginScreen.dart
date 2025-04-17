import 'package:finanzas_app/SignupScreen.dart';
import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'package:finanzas_app/db_helper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  void _login() async {
    final user = await DBHelper().loginUser(username, password);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Credenciales incorrectas')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Parte superior con fondo e ícono
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 18, 35, 47),
                image: DecorationImage(
                  image: AssetImage('assets/monedas.png'), // agrega este fondo
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                ),
              ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(
                    'assets/cerdito.png', // ícono de la alcancía
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
            ),

            // Formulario de login
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Iniciar', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Ingrese su usuario', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  SizedBox(height: 30),
                  Text('Usuario'),
                  SizedBox(height: 8),
                  TextField(
                    onChanged: (value) => username = value,
                    decoration: InputDecoration(
                      hintText: 'User',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Contraseña'),
                  SizedBox(height: 8),
                  TextField(
                    obscureText: true,
                    onChanged: (value) => password = value,
                    decoration: InputDecoration(
                      hintText: '******',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: Text('Iniciar sesión'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupScreen()),
                        );
                      },
                      child: Text('¿No tienes cuenta? Regístrate aquí'),
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
