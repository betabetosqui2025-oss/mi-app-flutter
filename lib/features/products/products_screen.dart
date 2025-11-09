import 'package:flutter/material.dart';
import 'package:sistema_de_ventas/core/services/api_service.dart';
import 'package:sistema_de_ventas/shared/models/product_model.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Producto> _productos = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    try {
      print('🔄 Cargando productos...');
      final response = await ApiService.obtenerProductosTemp();
      
      // ✅ CASTING A List<Producto>
      List<Producto> productos = (response as List).map((item) {
        return Producto.fromJson(item);
      }).toList();
      
      setState(() {
        _productos = productos;
        _isLoading = false;
      });
      
      print('✅ Productos cargados: ${productos.length}');
    } catch (e) {
      print('❌ Error cargando productos: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
    }
  }

  List<Producto> get _filteredProducts {
    if (_searchQuery.isEmpty) return _productos;
    return _productos.where((producto) =>
      producto.nombre?.toLowerCase().contains(_searchQuery.toLowerCase()) == true ||
      producto.codigoBarras?.toLowerCase().contains(_searchQuery.toLowerCase()) == true ||
      producto.categoria?.toLowerCase().contains(_searchQuery.toLowerCase()) == true
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarProductos,
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingIndicator()
          : _errorMessage.isNotEmpty
              ? _buildErrorWidget()
              : Column(
                  children: [
                    // Buscador
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar productos...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: _filteredProducts.isEmpty
                          ? _buildEmptyState()
                          : _buildProductList(),
                    ),
                  ],
                ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Cargando productos...'),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Error al cargar productos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cargarProductos,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'No hay productos' : 'No se encontraron productos',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          if (_searchQuery.isNotEmpty)
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                });
              },
              child: const Text('Limpiar búsqueda'),
            )
          else
            ElevatedButton(
              onPressed: _cargarProductos,
              child: const Text('Recargar'),
            ),
        ],
      ),
    );
  }

  // ✅ MÉTODO NUEVO: CONSTRUIR IMAGEN DEL PRODUCTO
  Widget _buildProductImage(Producto producto) {
    // Si el producto tiene imagen URL
    if (producto.imagenUrl != null && producto.imagenUrl!.isNotEmpty) {
      String imageUrl = producto.imagenUrl!;
      
      // Si es una ruta relativa, construir URL completa
      if (!imageUrl.startsWith('http')) {
        imageUrl = 'http://127.0.0.1:8080$imageUrl';
      }
      
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('❌ Error cargando imagen: $error');
            return _buildPlaceholderIcon(producto);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
        ),
      );
    }
    
    // Si no tiene imagen, mostrar icono placeholder
    return _buildPlaceholderIcon(producto);
  }

  // ✅ MÉTODO NUEVO: ICONO PLACEHOLDER
  Widget _buildPlaceholderIcon(Producto producto) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: producto.activo == false ? Colors.grey.shade300 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.inventory_2,
        color: producto.activo == false ? Colors.grey : Colors.blue,
      ),
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final producto = _filteredProducts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          elevation: 2,
          child: ListTile(
            leading: _buildProductImage(producto), // ✅ USAR MÉTODO DE IMAGEN
            title: Text(
              producto.nombre ?? 'Sin nombre',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: producto.activo == false ? Colors.grey : Colors.black,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                if (producto.codigoBarras?.isNotEmpty == true)
                  Text(
                    'Código: ${producto.codigoBarras}',
                    style: TextStyle(
                      color: producto.activo == false ? Colors.grey : null,
                    ),
                  ),
                Text(
                  'Precio: ${producto.precioFormateado}',
                  style: TextStyle(
                    color: producto.activo == false ? Colors.grey : null,
                  ),
                ),
                Text(
                  'Categoría: ${producto.categoria ?? "General"}',
                  style: TextStyle(
                    color: producto.activo == false ? Colors.grey : null,
                  ),
                ),
                if (producto.activo == false)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'INACTIVO',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            trailing: Icon(
              producto.activo == true ? Icons.check_circle : Icons.cancel,
              color: producto.activo == true ? Colors.green : Colors.red,
            ),
          ),
        );
      },
    );
  }
}