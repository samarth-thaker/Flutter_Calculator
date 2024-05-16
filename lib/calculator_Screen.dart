import 'package:calculator/buttonvalues.dart';
import 'package:flutter/material.dart';
import 'buttonvalues.dart';

class Calculatorscreen extends StatefulWidget {
  const Calculatorscreen({super.key});

  @override
  State<Calculatorscreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Calculatorscreen> {
  String number1 = "";
  String operand = "";
  String number2 = "";
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            //output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ), //buttons
            Wrap(
              children: Btn.buttonValues
                  .map((val) => SizedBox(
                        width: val == Btn.n0
                            ? (screenSize.width / 2)
                            : (screenSize.width / 4),
                        height: screenSize.width / 5,
                        child: buildButton(val),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(val) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(val),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
            onTap: () => onBtnTap(val),
            child: Center(
                child: Text(
              val,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ))),
      ),
    );
  }

  void onBtnTap(String val) {
    if (val == Btn.del) {
      delete();
    } else if (val == Btn.clr) {
      clear();
      return;
    } else if (val == Btn.per) {
      convertToPer();
    } else if (val == Btn.calc) {
      calculate();
      return;
    }
    append(val);
  }

  void convertToPer() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      // calculate before conversion
       final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
    }

    if (operand.isNotEmpty) {
      // cannot be converted
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  void calculate() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;
    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);
    double result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.mul:
        result = num1 * num2;
        break;
      case Btn.sub:
        result = num1 - num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
    }
    setState(() {
      number1 = result.toStringAsPrecision(3);

      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }

      operand = "";
      number2 = "";
    });
  }

  void clear() {
    setState(() {
      number1 = "";
      number2 = "";
      operand = "";
    });
  }

  void delete() {
    if (number2.isNotEmpty) {
    // Remove rightmost digit from number2
    number2 = number2.substring(0, number2.length - 1);
  } else if (operand.isNotEmpty) {
    // Clear operand
    operand = "";
  } else if (number1.isNotEmpty) {
    // Remove rightmost digit from number1
    number1 = number1.substring(0, number1.length - 1);
  }
  setState(() {});
  }

  void append(String val) {
    if (val != Btn.point && int.tryParse(val) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operand = val;
    } else if (number1.isEmpty || operand.isEmpty) {
      if (val == Btn.point && number1.contains(Btn.point)) {
        return;
      }
      if (val == Btn.point && (number1.isEmpty || number1 == Btn.n0)) {
        val = "0.";
      }
      number1 += val;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (val == Btn.point && number2.contains(Btn.point)) {
        return;
      }
      if (val == Btn.point && (number2.isEmpty || number2 == Btn.n0)) {
        val = "0.";
      }
      number2 += val;
    }
    setState(() {});
  }

  Color getBtnColor(val) {
    return [Btn.del, Btn.clr].contains(val)
        ? Colors.blueGrey
        : [Btn.add, Btn.divide, Btn.sub, Btn.mul, Btn.per].contains(val)
            ? Colors.orange
            : Colors.black45;
  }
}
