import 'package:flutter/material.dart';
import 'package:finanzas_app/db_helper.dart';
import 'package:finanzas_app/modelos/categoria.dart';
import 'package:finanzas_app/modelos/gasto.dart';
import 'package:finanzas_app/pantallas/pantalla_formulario_gasto.dart';

class PantallaCategoria extends StatefulWidget {
  final Categoria categoria;
  const PantallaCategoria({super.key, required this.categoria});

  @override
  State<PantallaCategoria> createState() => _PantallaCategoriaState();
}

class _PantallaCategoriaState extends State<PantallaCategoria> {
  List<Gasto> gastos = [];
  int total = 0;

  @override
  void initState() {
    super.initState();
    _cargarGastos();
  }

  Future<void> _cargarGastos() async {
    final datos = await DBHelper().obtenerGastosPorCategoria(widget.categoria.nombre);
    final lista = datos.map((mapa) => Gasto.desdeMapa(mapa)).toList();
    final suma = lista.fold<int>(0, (prev, e) => prev + e.monto);
    setState(() {
      gastos = lista;
      total = suma;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoria.nombre)),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: ListTile(
              leading: Image.asset(widget.categoria.rutaIcono, width: 40, height: 40),
              title: Text(widget.categoria.nombre.toUpperCase()),
              subtitle: Text('Total: \$${total.toString()}'),
            ),
          ),
          const Divider(),
          Expanded(
            child: gastos.isEmpty
                ? Center(child: Text('No hay gastos registrados'))
                : ListView.builder(
                    itemCount: gastos.length,
                    itemBuilder: (_, i) {
                      final gasto = gastos[i];
                      return ListTile(
                        title: Text('\$${gasto.monto}'),
                        subtitle: Text(
                          '${gasto.fecha.day}/${gasto.fecha.month}/${gasto.fecha.year}',
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PantallaFormularioGasto(categoria: widget.categoria.nombre),
            ),
          );
          _cargarGastos();
        },
      ),
    );
  }
}
