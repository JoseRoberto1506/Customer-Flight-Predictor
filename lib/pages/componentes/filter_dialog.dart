import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final void Function(String) onFilterSelected;
  final List<String> satisfactionOptions;

  const FilterDialog({
    required this.onFilterSelected,
    required this.satisfactionOptions,
  });

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String _selectedFilter = 'CPF';
  String _searchValue = '';
  String _selectedSatisfaction = '0 - Não Informado';
  bool _showTextField = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[800],
      title: const Text(
        'Filtrar por',
        style: TextStyle(
          color: Colors.lightBlueAccent,
          fontSize: 16,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DropdownButton<String>(
            dropdownColor: Color(0xFF313133),
            value: _selectedFilter,
            items: ['CPF', 'Satisfação'].map((String filter) {
              return DropdownMenuItem<String>(
                value: filter,
                child: Text(
                  filter,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedFilter = newValue ?? 'CPF';
                _showTextField = _selectedFilter != 'Satisfação';
              });
            },
          ),
          if (_selectedFilter ==
              'Satisfação') // Mostrar o Dropdown apenas quando o filtro for Satisfação

            DropdownButton<String>(
              dropdownColor: Color(0xFF313133),
              value: _selectedSatisfaction,
              items: widget.satisfactionOptions.map((String satisfaction) {
                return DropdownMenuItem<String>(
                  value: satisfaction,
                  child: Text(
                    satisfaction,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSatisfaction = newValue ?? '0 - Não Informado';
                });
              },
            ),
          const SizedBox(height: 8),
          Visibility(
            visible: _showTextField,
            child: TextField(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              onChanged: (value) {
                _searchValue = value;
              },
              decoration: const InputDecoration(
                  labelText: 'Pesquisa',
                  hintStyle: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 12,
                  )),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            final filter =
                '$_selectedFilter|$_searchValue|$_selectedSatisfaction';
            widget.onFilterSelected(filter);
            Navigator.of(context).pop();
          },
          child: const Text('Filtrar'),
        ),
      ],
    );
  }
}
