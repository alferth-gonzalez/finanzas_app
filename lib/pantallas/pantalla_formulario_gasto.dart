import 'package:flutter/material.dart';
import 'package:finanzas_app/db_helper.dart';

class PantallaFormularioGasto extends StatefulWidget {
  final String categoria;
  const PantallaFormularioGasto({super.key, required this.categoria});

  @override
  State<PantallaFormularioGasto> createState() => _PantallaFormularioGastoState();
}

class _PantallaFormularioGastoState extends State<PantallaFormularioGasto> {
  String entrada = '';
  String descripcion = '';


  void _alPresionarTecla(String valor) {
    setState(() {
      if (valor == '⌫') {
        if (entrada.isNotEmpty) entrada = entrada.substring(0, entrada.length - 1);
      } else {
        entrada += valor;
      }
    });
  }

  // void _guardar() async {
  //   final monto = int.tryParse(entrada) ?? 0;
  //   if (monto > 0) {
  //     await DBHelper().insertarGasto(
  //       widget.categoria,
  //       monto,
  //       descripcion,
  //       DateTime.now().toIso8601String(),
  //     );

  //     Navigator.pop(context);
  //   }
  // }

  void _guardar() async {
    try {
      final monto = int.tryParse(entrada) ?? 0;
      if (monto > 0) {
        await DBHelper().insertarGasto(
          widget.categoria,
          monto,
          descripcion,
          DateTime.now().toIso8601String(),
        );
        print("✅ Gasto guardado");
        Navigator.pop(context);
      } else {
        print("⚠️ Monto inválido");
      }
    } catch (e) {
      print("❌ Error al guardar: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    final teclas = ['7', '8', '9', '4', '5', '6', '1', '2', '3', '⌫', '0', ''];

    return Scaffold(
      appBar: AppBar(title: const Text('Formulario')),
      body: Column(
        children: [
          // Tarjeta de entrada
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.categoria.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '\$ $entrada',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    onChanged: (value) => descripcion = value,
                    decoration: InputDecoration(
                      hintText: 'Descripción del gasto',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _guardar,
                      child: const Text('Guardar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(thickness: 2),

          // Teclado personalizado
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: teclas.length,
              itemBuilder: (_, i) {
                final tecla = teclas[i];
                return tecla.isEmpty
                    ? SizedBox.shrink()
                    : GestureDetector(
                        onTap: () => _alPresionarTecla(tecla),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade900,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tecla,
                            style: const TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
