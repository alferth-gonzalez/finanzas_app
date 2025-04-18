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
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text('Gastos'),
        actions: const [Icon(Icons.tune)],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Tarjeta total
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(widget.categoria.rutaIcono, width: 36, height: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.categoria.nombre.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        '\$${total.toString()}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('+49,89%', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.account_balance_wallet_outlined),
              ],
            ),
          ),

          // Filtros
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Row(children: [Icon(Icons.expand_less), Text(' Short by')]),
                Row(children: [Text('Last 24h'), Icon(Icons.expand_more)]),
              ],
            ),
          ),

          // Lista de gastos
          Expanded(
            child: gastos.isEmpty
                ? const Center(child: Text('No hay gastos registrados'))
                : ListView.builder(
                    itemCount: gastos.length,
                    itemBuilder: (_, i) {
                      final gasto = gastos[i];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.deepPurple,
                              ),
                              child: const Icon(Icons.attach_money, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(gasto.descripcion.toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black)),
                                  Text('\$${gasto.monto}',
                                      style: const TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Text(
                                  '\$89.759',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                Text(
                                  '+4,89%',
                                  style: TextStyle(color: Colors.green),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
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
