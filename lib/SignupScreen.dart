import 'package:flutter/material.dart';
import 'package:finanzas_app/db_helper.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String correo = '';
  String password = '';
  DateTime? fechaNacimiento;

  void _selectFechaNacimiento() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != fechaNacimiento) {
      setState(() {
        fechaNacimiento = picked;
      });
    }
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      final existe = await DBHelper().emailExists(correo);
      if (existe) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('El correo ya está registrado')),
        );
        return;
      }

      try {
        await DBHelper().registerUser(
          nombre,
          correo,
          password,
          fechaNacimiento != null ? fechaNacimiento!.toIso8601String() : '',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cuenta creada exitosamente')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la cuenta')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Parte superior decorativa
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 18, 35, 47),
                image: DecorationImage(
                  image: AssetImage('assets/monedas.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(60),
                ),
              ),
              child: SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),

            // Formulario
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Crear nueva rcuenta',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Listo para registrarte? ingresa aqui!',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                    SizedBox(height: 30),

                    // Nombre
                    Text('NOMBRE'),
                    SizedBox(height: 8),
                    TextFormField(
                      onChanged: (value) => nombre = value,
                      validator: (value) =>
                          value!.isEmpty ? 'Campo requerido' : null,
                      decoration: _inputDecoration('Ingresa nombre'),
                    ),
                    SizedBox(height: 20),

                    // Correo
                    Text('CORREO'),
                    SizedBox(height: 8),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => correo = value,
                      validator: (value) =>
                          value!.isEmpty ? 'Campo requerido' : null,
                      decoration:
                          _inputDecoration('estudiante@uts.edu.co'),
                    ),
                    SizedBox(height: 20),

                    // Contraseña
                    Text('CONTRASEÑA'),
                    SizedBox(height: 8),
                    TextFormField(
                      obscureText: true,
                      onChanged: (value) => password = value,
                      validator: (value) =>
                          value!.isEmpty ? 'Campo requerido' : null,
                      decoration: _inputDecoration('******'),
                    ),
                    SizedBox(height: 20),

                    // Fecha de nacimiento
                    Text('FECHA NACIMIENTO'),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: _selectFechaNacimiento,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          fechaNacimiento == null
                              ? 'Select'
                              : '${fechaNacimiento!.day}/${fechaNacimiento!.month}/${fechaNacimiento!.year}',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Botón
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _signup,
                        child: Text('Sign up'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade200,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
}
