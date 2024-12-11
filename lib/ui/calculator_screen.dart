//S.Hariprasath
//IM/2021/077

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/calculator_controller.dart';

//I used this to create a statefull widget
class CalculatorHome extends StatefulWidget {
  const CalculatorHome({
    super.key,
    required bool isDarkMode,
    required void Function() onThemeToggle,
  });

  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

//Used the calculatorcontroller class here
class _CalculatorHomeState extends State<CalculatorHome> {
  final CalculatorController _controller = CalculatorController();
  String display = '0';
  String input = '';
  bool showExtraButtons = false;
  bool isDarkMode = true;
  bool resultDisplayed = false;

//this is used to set the UI color based on the theme
  @override
  void initState() {
    super.initState();
    _setSystemUIOverlayStyle(isDarkMode);
  }

  void _setSystemUIOverlayStyle(bool darkMode) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor:
            darkMode ? const Color(0xFF22252D) : Colors.white,
        systemNavigationBarIconBrightness:
            darkMode ? Brightness.light : Brightness.dark,
      ),
    );
  }

  void buttonPressed(String value) {
    setState(() {
      if (resultDisplayed &&
          ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.']
              .contains(value)) {
        display = '0';
        input = '';
        resultDisplayed = false;
      }
      var result = _controller.handleButtonPress(value, display, input);
      display = result['display']!;
      input = result['input']!;

      if (value == '=') {
        resultDisplayed = true;
      }
    });
  }

//this i used to open the history bar when clicked and the feature inside that bar.
  void openHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('History'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _controller.history.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          _controller.history[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _controller.clearHistory();
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Clear History'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//This whole thing is used to handle the button in my calc.
  Widget buildButton(String text) {
    Color buttonColor;
    Color textColor;

    if (isDarkMode) {
      if (['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0']
          .contains(text)) {
        buttonColor = const Color(0xFF292D36);
        textColor = Colors.white;
      } else if (['AC', '⌫'].contains(text)) {
        buttonColor = const Color(0xFF7F8489);
        textColor = Colors.black;
      } else if (text == '=') {
        buttonColor = const Color(0xFF009688);
        textColor = Colors.white;
      } else {
        buttonColor = Colors.white;
        textColor = const Color(0xFF009688);
      }
    } else {
      if (['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0']
          .contains(text)) {
        buttonColor = Colors.white;
        textColor = Colors.black;
      } else if (['AC', '⌫'].contains(text)) {
        buttonColor = Colors.white;
        textColor = Colors.black;
      } else if (text == '=') {
        buttonColor = const Color(0xFF009688);
        textColor = Colors.white;
      } else {
        buttonColor = Colors.white;
        textColor = const Color(0xFF009688);
      }
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ElevatedButton(
          onPressed: () => buttonPressed(text),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 24),
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            elevation: 6,
            shadowColor: Colors.black.withOpacity(0.5),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 26, color: textColor),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF22252D) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF22252D) : Colors.white,
        elevation: 0,
        title: const Text(
          'EazyCalc',
          style: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        ),
        //this i used to create apop up menu for the extra feature buttons
        actions: [
          PopupMenuButton<int>(
            icon: Icon(
              Icons.more_vert,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onSelected: (value) {
              if (value == 1) {
                setState(() {
                  isDarkMode = !isDarkMode;
                  _setSystemUIOverlayStyle(isDarkMode);
                });
              } else if (value == 2) {
                openHistory();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(
                      isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: isDarkMode
                          ? Colors.white
                          : const Color.fromARGB(255, 112, 109, 109),
                    ),
                    const SizedBox(width: 8),
                    Text(isDarkMode ? 'Light Mode' : 'Dark Mode'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  children: [
                    const Icon(Icons.history, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text('History'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            //this is the display section for both input and te results.
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      input,
                      style: TextStyle(
                        fontSize: 24,
                        color: isDarkMode ? Colors.grey : Colors.black45,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      display,
                      key: const Key('display'),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    showExtraButtons = !showExtraButtons;
                  });
                },
                icon: Icon(
                  showExtraButtons
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: isDarkMode ? Colors.white : Colors.grey,
                  size: 32,
                ),
              ),
            ],
          ),
          if (showExtraButtons)
            Column(
              children: [
                Row(
                  children: [
                    buildButton('√'),
                    buildButton('π'),
                    buildButton('^'),
                    buildButton('()'),
                  ],
                ),
              ],
            ),
          Column(
            children: [
              Row(
                children: <Widget>[
                  buildButton('AC'),
                  buildButton('⌫'),
                  buildButton('%'),
                  buildButton('÷'),
                ],
              ),
              Row(
                children: <Widget>[
                  buildButton('7'),
                  buildButton('8'),
                  buildButton('9'),
                  buildButton('×'),
                ],
              ),
              Row(
                children: <Widget>[
                  buildButton('4'),
                  buildButton('5'),
                  buildButton('6'),
                  buildButton('-'),
                ],
              ),
              Row(
                children: <Widget>[
                  buildButton('1'),
                  buildButton('2'),
                  buildButton('3'),
                  buildButton('+'),
                ],
              ),
              Row(
                children: <Widget>[
                  buildButton('0'),
                  buildButton('.'),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        onPressed: () => buttonPressed('='),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          backgroundColor: const Color(0xFF009688),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: const Text(
                          '=',
                          style: TextStyle(fontSize: 26, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
