import 'package:flutter/material.dart';
import '../models/tipo_propiedad.dart';
import '../config/theme.dart';

/// Bottom sheet con los filtros avanzados de búsqueda (RF-010).
/// Se abre desde el HomeScreen al tocar el ícono de filtro.
///
/// Los filtros por ahora solo muestran la UI.
/// TODO: Devolver los valores al HomeScreen para filtrar la lista.
class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // Estado de cada filtro.
  RangeValues _rangoPrecio = const RangeValues(500000, 5000000);
  TipoPropiedad? _tipoSeleccionado;
  int _minHabitaciones = 0;
  int _minBanos = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Solo ocupa lo que necesita.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // La barrita gris arriba (indicador visual de que se puede arrastrar).
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Título.
          const Text(
            'Filtrar propiedades',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          // ─── Rango de precio ───
          const Text(
            'Rango de precio (mensual)',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${_rangoPrecio.start.toStringAsFixed(0)} - \$${_rangoPrecio.end.toStringAsFixed(0)}',
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          RangeSlider(
            values: _rangoPrecio,
            min: 0,
            max: 10000000,
            divisions: 20,
            labels: RangeLabels(
              '\$${_rangoPrecio.start.toStringAsFixed(0)}',
              '\$${_rangoPrecio.end.toStringAsFixed(0)}',
            ),
            onChanged: (values) {
              setState(() => _rangoPrecio = values);
            },
          ),
          const SizedBox(height: 16),

          // ─── Tipo de propiedad ───
          const Text(
            'Tipo de propiedad',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              // "Todos" = sin filtro de tipo.
              ChoiceChip(
                label: const Text('Todos'),
                selected: _tipoSeleccionado == null,
                onSelected: (_) {
                  setState(() => _tipoSeleccionado = null);
                },
              ),
              // Un chip por cada tipo del enum.
              ...TipoPropiedad.values.map((tipo) {
                return ChoiceChip(
                  label: Text(tipo.label),
                  selected: _tipoSeleccionado == tipo,
                  onSelected: (_) {
                    setState(() => _tipoSeleccionado = tipo);
                  },
                );
              }),
            ],
          ),
          const SizedBox(height: 16),

          // ─── Habitaciones mínimas ───
          _buildContador(
            'Habitaciones mínimas',
            _minHabitaciones,
            (valor) => setState(() => _minHabitaciones = valor),
          ),
          const SizedBox(height: 12),

          // ─── Baños mínimos ───
          _buildContador(
            'Baños mínimos',
            _minBanos,
            (valor) => setState(() => _minBanos = valor),
          ),
          const SizedBox(height: 24),

          // ─── Botones ───
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Restablece todos los filtros a sus valores iniciales.
                    setState(() {
                      _rangoPrecio = const RangeValues(500000, 5000000);
                      _tipoSeleccionado = null;
                      _minHabitaciones = 0;
                      _minBanos = 0;
                    });
                  },
                  child: const Text('Limpiar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Devolver filtros al HomeScreen y aplicar.
                    Navigator.pop(context);
                  },
                  child: const Text('Aplicar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Contador con botones + y - para habitaciones/baños.
  Widget _buildContador(String label, int valor, void Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        Row(
          children: [
            IconButton(
              onPressed: valor > 0 ? () => onChanged(valor - 1) : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: AppTheme.primaryColor,
            ),
            Text(
              '$valor',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: valor < 10 ? () => onChanged(valor + 1) : null,
              icon: const Icon(Icons.add_circle_outline),
              color: AppTheme.primaryColor,
            ),
          ],
        ),
      ],
    );
  }
}
