import 'package:flutter/material.dart';

void main() {
  runApp(const UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Unit Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const UnitConverterScreen(),
    );
  }
}

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final TextEditingController _inputController = TextEditingController(
    text: '10',
  );
  String _category = 'Length';

  final Map<String, List<String>> _units = {
    'Length': ['Meters', 'Kilometers', 'Miles', 'Feet'],
    'Weight': ['Kilograms', 'Grams', 'Pounds', 'Ounces'],
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
  };

  String _fromUnit = 'Meters';
  String _toUnit = 'Feet';

  void _onCategoryChanged(String newCat) {
    setState(() {
      _category = newCat;
      _fromUnit = _units[newCat]![0];
      _toUnit = _units[newCat]![1];
    });
  }

  double get _convertedValue {
    final val = double.tryParse(_inputController.text.trim()) ?? 0.0;
    if (_fromUnit == _toUnit) return val;

    if (_category == 'Length') {
      double meters = val;
      if (_fromUnit == 'Kilometers') meters = val * 1000;
      if (_fromUnit == 'Miles') meters = val * 1609.34;
      if (_fromUnit == 'Feet') meters = val * 0.3048;

      if (_toUnit == 'Kilometers') return meters / 1000;
      if (_toUnit == 'Miles') return meters / 1609.34;
      if (_toUnit == 'Feet') return meters / 0.3048;
      return meters;
    } else if (_category == 'Weight') {
      double kg = val;
      if (_fromUnit == 'Grams') kg = val / 1000;
      if (_fromUnit == 'Pounds') kg = val * 0.453592;
      if (_fromUnit == 'Ounces') kg = val * 0.0283495;

      if (_toUnit == 'Grams') return kg * 1000;
      if (_toUnit == 'Pounds') return kg / 0.453592;
      if (_toUnit == 'Ounces') return kg / 0.0283495;
      return kg;
    } else {
      double celsius = val;
      if (_fromUnit == 'Fahrenheit') celsius = (val - 32) * 5 / 9;
      if (_fromUnit == 'Kelvin') celsius = val - 273.15;

      if (_toUnit == 'Fahrenheit') return (celsius * 9 / 5) + 32;
      if (_toUnit == 'Kelvin') return celsius + 273.15;
      return celsius;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUnits = _units[_category]!;

    return Scaffold(
      appBar: AppBar(title: const Text('Unit Converter'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'Length',
                  label: Text('Length'),
                  icon: Icon(Icons.straighten),
                ),
                ButtonSegment(
                  value: 'Weight',
                  label: Text('Weight'),
                  icon: Icon(Icons.scale),
                ),
                ButtonSegment(
                  value: 'Temperature',
                  label: Text('Temp'),
                  icon: Icon(Icons.thermostat),
                ),
              ],
              selected: {_category},
              onSelectionChanged: (val) => _onCategoryChanged(val.first),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    TextField(
                      controller: _inputController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Enter Value',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _fromUnit,
                            decoration: const InputDecoration(
                              labelText: 'From',
                              border: OutlineInputBorder(),
                            ),
                            items: currentUnits
                                .map(
                                  (u) => DropdownMenuItem(
                                    value: u,
                                    child: Text(u),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _fromUnit = val);
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(Icons.arrow_forward),
                        ),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _toUnit,
                            decoration: const InputDecoration(
                              labelText: 'To',
                              border: OutlineInputBorder(),
                            ),
                            items: currentUnits
                                .map(
                                  (u) => DropdownMenuItem(
                                    value: u,
                                    child: Text(u),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _toUnit = val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.teal.shade800,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Text(
                    'Converted Result ($_toUnit)',
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _convertedValue.toStringAsFixed(2),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
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
