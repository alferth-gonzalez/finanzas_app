import 'package:flutter/material.dart';
import 'package:finanzas_app/db_helper.dart';
import 'package:finanzas_app/modelos/categoria.dart';
import 'package:finanzas_app/pantallas/pantalla_categoria.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Map<String, int> _totales = {};

  @override
  void initState() {
    super.initState();
    _cargarTotales();
  }

  Future<void> _cargarTotales() async {
    final data = await DBHelper().totalesPorCategoria();
    setState(() => _totales = data);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _pantallas => [
        MainWalletScreen(totales: _totales, onRefresh: _cargarTotales),
        Center(child: Text('Transacciones')),
        Center(child: Text('Menú')),
        Center(child: Text('Estadísticas')),
        Center(child: Text('Configuración')),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(child: _pantallas[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            label: 'Transacciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menú',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Estadísticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }
}

class MainWalletScreen extends StatelessWidget {
  final Map<String, int> totales;
  final VoidCallback onRefresh;

  const MainWalletScreen({
    Key? key,
    required this.totales,
    required this.onRefresh,
  }) : super(key: key);

  int _calcularBalanceTotal() {
    return totales.values.fold(0, (sum, val) => sum + val);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Encabezado
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/user-icon.png'),
                radius: 20,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Finanzas\npersonales',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.tune),
            ],
          ),
        ),

        // Tarjeta balance
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Total Balance', style: TextStyle(fontSize: 16)),
                  const Spacer(),
                  const Icon(Icons.account_balance_wallet_outlined),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '\$${_calcularBalanceTotal()}',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '+49,89%',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),

        // Filtros
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(children: [Icon(Icons.expand_less), Text(' Ordenar')]),
              Row(children: [Text('Hoy'), Icon(Icons.expand_more)]),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Lista de categorías
        Expanded(
          child: ListView(
            children: categorias.map((cat) {
              final total = totales[cat.nombre] ?? 0;
              return GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PantallaCategoria(categoria: cat),
                    ),
                  );
                  onRefresh();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.asset(cat.rutaIcono, width: 36, height: 36),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cat.nombre.toUpperCase(),
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('\$${total.toString()}',
                                style: TextStyle(color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      const Text('+4,89%', style: TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
