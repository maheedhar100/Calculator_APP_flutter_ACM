import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Calculator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = "0";
  String _outputHistory = "";
  double _num1 = 0;
  double _num2 = 0;
  String _operand = "";
  bool _shouldResetOutput = false;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        // Clear all
        _output = "0";
        _outputHistory = "";
        _num1 = 0;
        _num2 = 0;
        _operand = "";
        _shouldResetOutput = false;
      } else if (buttonText == "CE") {
        // Clear entry
        _output = "0";
      } else if (buttonText == "+" || 
                 buttonText == "-" || 
                 buttonText == "×" || 
                 buttonText == "÷") {
        // Operator pressed
        if (_operand.isNotEmpty && !_shouldResetOutput) {
          _calculate();
        }
        _num1 = double.parse(_output);
        _operand = buttonText;
        _outputHistory = "$_output $_operand ";
        _shouldResetOutput = true;
      } else if (buttonText == "=") {
        // Equals pressed
        if (_operand.isNotEmpty) {
          _num2 = double.parse(_output);
          _calculate();
          _outputHistory = "";
          _operand = "";
        }
      } else if (buttonText == ".") {
        // Decimal point
        if (_shouldResetOutput) {
          _output = "0.";
          _shouldResetOutput = false;
        } else if (!_output.contains(".")) {
          _output += ".";
        }
      } else {
        // Number pressed
        if (_shouldResetOutput || _output == "0") {
          _output = buttonText;
          _shouldResetOutput = false;
        } else {
          _output += buttonText;
        }
      }
    });
  }

  void _calculate() {
    double result = 0;
    
    switch (_operand) {
      case "+":
        result = _num1 + _num2;
        break;
      case "-":
        result = _num1 - _num2;
        break;
      case "×":
        result = _num1 * _num2;
        break;
      case "÷":
        if (_num2 != 0) {
          result = _num1 / _num2;
        } else {
          _output = "Error";
          return;
        }
        break;
    }
    
    // Format the result to remove unnecessary decimals
    if (result == result.roundToDouble()) {
      _output = result.toInt().toString();
    } else {
      _output = result.toString();
    }
    
    _num1 = result;
    _shouldResetOutput = true;
  }

  Widget _buildButton(String text, {Color? color, Color? textColor}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[300],
            foregroundColor: textColor ?? Colors.black,
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => _buttonPressed(text),
          child: Text(
            text,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Calculator', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Display area
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // History display
                  Text(
                    _outputHistory,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Main output display
                  Text(
                    _output,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Button area
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  // Row 1: Clear buttons
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton("C", color: Colors.red[400], textColor: Colors.white),
                        _buildButton("CE", color: Colors.orange[400], textColor: Colors.white),
                        _buildButton("", color: Colors.grey[300]), // Empty button for spacing
                        _buildButton("÷", color: Colors.blue[400], textColor: Colors.white),
                      ],
                    ),
                  ),
                  
                  // Row 2: 7, 8, 9, ×
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton("7"),
                        _buildButton("8"),
                        _buildButton("9"),
                        _buildButton("×", color: Colors.blue[400], textColor: Colors.white),
                      ],
                    ),
                  ),
                  
                  // Row 3: 4, 5, 6, -
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton("4"),
                        _buildButton("5"),
                        _buildButton("6"),
                        _buildButton("-", color: Colors.blue[400], textColor: Colors.white),
                      ],
                    ),
                  ),
                  
                  // Row 4: 1, 2, 3, +
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton("1"),
                        _buildButton("2"),
                        _buildButton("3"),
                        _buildButton("+", color: Colors.blue[400], textColor: Colors.white),
                      ],
                    ),
                  ),
                  
                  // Row 5: 0, ., =
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton("0"),
                        _buildButton("."),
                        _buildButton("", color: Colors.grey[300]), // Empty button for spacing
                        _buildButton("=", color: Colors.green[400], textColor: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
