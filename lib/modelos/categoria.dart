class Categoria {
  final String nombre;
  final String rutaIcono;

  const Categoria({required this.nombre, required this.rutaIcono});
}

const List<Categoria> categorias = [
  // Categoria(nombre: 'Transporte', rutaIcono: 'assets/categorias/icono_transporte.png'),
  // Categoria(nombre: 'Alimentación', rutaIcono: 'assets/categorias/icono_alimentacion.png'),
  // Categoria(nombre: 'Educación', rutaIcono: 'assets/categorias/icono_educacion.png'),
  // Categoria(nombre: 'Entretenimiento', rutaIcono: 'assets/categorias/icono_entretenimiento.png'),

  Categoria(nombre: 'Transporte', rutaIcono: 'assets/carro-icon.png'),
  Categoria(nombre: 'Alimentación', rutaIcono: 'assets/alimentacion-icon.png'),
  Categoria(nombre: 'Educación', rutaIcono: 'assets/educacion-icon.png'),
  Categoria(nombre: 'Entretenimiento', rutaIcono: 'assets/entretenimiento-icon.png'),
];
