//S.Hariprasath
//IM/2021/077

import "package:math_expressions/math_expressions.dart";
import 'dart:math';

class CalculatorController {
  double num1 = 0.0;
  String operation = '';
  bool isSecondInput = false;
  bool resultDisplayed = false;

//i used to store the value in strings
  String expression = '';

//this will store the past calculations done
  List<String> history = [];

  void clearHistory() {
    history.clear();
  }

//usd to handle each buttons pressed
  Map<String, String> handleButtonPress(
      String value, String display, String input) {
    if (value == 'AC') {
      num1 = 0.0;
      operation = '';
      isSecondInput = false;
      expression = '';
      resultDisplayed = false;
      return {'display': '0', 'input': ''};
    } else if (value == '⌫') {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
      if (display.isNotEmpty && display != '0') {
        display = display.substring(0, display.length - 1);
        if (display.isEmpty) display = '0';
      }
      expression = input;
      return {'display': display, 'input': input};
    } else if (['+', '-', '×', '÷', '%', '^', '√', '()'].contains(value)) {
      if (resultDisplayed) {
        input = display;
        expression = display;
        resultDisplayed = false;
      }
      if (value == '()') {
        int openBrackets = input.split('(').length - 1;
        int closeBrackets = input.split(')').length - 1;

        if (openBrackets > closeBrackets) {
          value = ')';
        } else {
          value = '(';
        }

        input += value;
        expression += value;
        return {'display': display, 'input': input};
      }
      if (input.isNotEmpty &&
          ['+', '-', '×', '÷', '%', '^'].contains(input[input.length - 1])) {
        input = input.substring(0, input.length - 1) + value;
        expression = expression.substring(0, expression.length - 1) +
            (value == '×'
                ? '*'
                : value == '÷'
                    ? '/'
                    : value);
        return {'display': display, 'input': input};
      }

      if (value == '√') {
        try {
          double num = double.parse(display);
          if (num < 0) {
            throw Exception("Invalid input for square root");
          }
          double result = sqrt(num);
          display = formatResult(result);
          input = '√($num)';
          expression = 'sqrt($num)';
          return {'display': display, 'input': input};
        } catch (e) {
          return {'display': 'Error', 'input': ''};
        }
      }

      if (value == '%') {
        try {
          if (operation.isNotEmpty) {
            double num2 = double.parse(display);
            double percentage = (num1 * num2) / 100;
            display = formatResult(percentage);
            input += '%';
            expression = percentage.toString();
          } else {
            double num = double.parse(display);
            double result = num / 100;
            display = formatResult(result);
            input += '%';
            expression = result.toString();
          }
          return {'display': display, 'input': input};
        } catch (e) {
          return {'display': 'Error', 'input': ''};
        }
      }

      if (operation.isNotEmpty) {
        try {
          num1 = calculate(num1, double.parse(display), operation);
          if (num1 == double.infinity || num1.isNaN) {
            throw Exception("Invalid operation");
          }
          display = formatResult(num1);
        } catch (e) {
          return {'display': 'Error', 'input': ''};
        }
      } else {
        num1 = double.parse(display);
      }

      operation = value;
      isSecondInput = true;
      input += value;
      expression += value == '×'
          ? '*'
          : value == '÷'
              ? '/'
              : value;
      return {'display': '0', 'input': input};
    } else if (value == '=') {
      try {
        double result = evaluateExpression(expression);
        if (result == double.infinity || result.isNaN) {
          throw Exception("Invalid operation");
        }
        history.add('$expression = ${formatResult(result)}');

        resultDisplayed = true;
        return {'display': formatResult(result), 'input': ''};
      } catch (e) {
        return {'display': 'Error', 'input': ''};
      }
    } else if (value == 'π') {
      if (resultDisplayed) {
        input = '';
        resultDisplayed = false;
      }
      input += 'π';
      expression += '${pi.toString()}';
      return {'display': '3.14159265', 'input': input};
    } else {
      if (resultDisplayed) {
        display = '0';
        input = '';
        expression = '';
        resultDisplayed = false;
      }

      if (value == '.') {
        if (display.contains('.')) {
          return {'display': display, 'input': input};
        }
      }
      display = display == '0' ? value : display + value;
      input += value;
      expression += value;
      return {'display': display, 'input': input};
    }
  }

//this is used for basic calculation operations
  double calculate(double n1, double n2, String op) {
    switch (op) {
      case '+':
        return n1 + n2;
      case '-':
        return n1 - n2;
      case '×':
        return n1 * n2;
      case '÷':
        if (n2 == 0.0) {
          throw Exception("Cannot divide by zero");
        }
        return n1 / n2;
      case '%':
        return (n1 * n2) / 100;
      case '^':
        return pow(n1, n2).toDouble();
      default:
        return n2;
    }
  }

//to display reults on float value
  String formatResult(double result) {
    const int maxDecimalPlaces = 8;
    const double largeNumberThreshold = 1e12;
    if (result.abs() >= largeNumberThreshold ||
        result.isNaN ||
        result.isInfinite) {
      return result.toStringAsExponential(2);
    }

    String formattedResult = result.toStringAsFixed(maxDecimalPlaces);

    if (formattedResult.contains('.') && formattedResult.endsWith('0')) {
      formattedResult = formattedResult.replaceAll(RegExp(r'0*$'), '');
    }
    if (formattedResult.endsWith('.')) {
      formattedResult =
          formattedResult.substring(0, formattedResult.length - 1);
    }

    return formattedResult;
  }

  double evaluateExpression(String expression) {
    try {
      Parser parser = Parser();
      Expression exp = parser.parse(expression);
      double result = exp.evaluate(EvaluationType.REAL, ContextModel());
      if (result == double.infinity || result.isNaN) {
        throw Exception("Invalid operation");
      }
      return result;
    } catch (e) {
      throw Exception('Invalid Expression');
    }
  }

  List<String> getHistory() {
    return List.unmodifiable(history);
  }
}
