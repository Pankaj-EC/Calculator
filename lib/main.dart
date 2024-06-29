import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  bool isGujarati = false;
  bool isSoundEnabled = true;
  String input = "";
  String output = "0";
  List<String> historyList = [];
  String _output = "0";
  double num1 = 0;
  double num2 = 0;
  String operand = "";
  FlutterTts flutterTts = FlutterTts();

  final Map<String, String> engToGuj = {
    "0": "૦", "1": "૧", "2": "૨", "3": "૩", "4": "૪",
    "5": "૫", "6": "૬", "7": "૭", "8": "૮", "9": "૯"
  };

  @override
  void initState() {
    super.initState();
    initTts();
  }

  Future<void> initTts() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  String getDisplayText(String text) {
    if (isGujarati) {
      return text.split('').map((e) => engToGuj[e] ?? e).join();
    }
    return text;
  }

  bool isNumeric(String str) {
    try {
      double.parse(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _speak(String text) async {
    if (isSoundEnabled) {
      await flutterTts.setLanguage(isGujarati ? "gu-IN" : "en-US");
      await flutterTts.speak(text);
    }
  }

  void buttonPressed(String buttonText) {
    if (buttonText == "C") {
      _output = "0";
      input = "";
      num1 = 0;
      num2 = 0;
      operand = "";
    } else if (buttonText == "⌫") {
      _output = _output.length > 1
          ? _output.substring(0, _output.length - 1)
          : "0";
      input = input.length > 1
          ? input.substring(0, input.length - 1)
          : "";
    } else if (buttonText == "+" || buttonText == "-" || buttonText == "×" || buttonText == "÷") {
      if (isNumeric(_output)) {
        num1 = double.parse(_output);
        operand = buttonText;
        _output = "0";
        input += buttonText;
      }
    } else if (buttonText == ".") {
      if (!_output.contains(".")) {
        _output += buttonText;
        input += buttonText;
      }
    } else if (buttonText == "=") {
      if (isNumeric(_output)) {
        num2 = double.parse(_output);

        switch (operand) {
          case "+":
            _output = (num1 + num2).toString();
            break;
          case "-":
            _output = (num1 - num2).toString();
            break;
          case "×":
            _output = (num1 * num2).toString();
            break;
          case "÷":
            _output = (num1 / num2).toString();
            break;
        }

        historyList.add(getDisplayText("$num1 $operand $num2=$_output"));

        num1 = 0;
        num2 = 0;
        operand = "";
        input = "";

        // Speak the result
        _speak(_output);
      }
    } else {
      if (_output == "0") {
        _output = buttonText;
      } else {
        _output += buttonText;
      }
      input += buttonText;
    }

    setState(() {
      output = _output;
    });
  }

  Widget buildButton(String buttonText, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        child: ElevatedButton(
          onPressed: () => buttonPressed(buttonText),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(20),
          ),
          child: Text(
            getDisplayText(buttonText),
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
        actions: [
          IconButton(
            icon: Icon(
              isSoundEnabled ? Icons.volume_up : Icons.volume_off,
            ),
            onPressed: () {
              setState(() {
                isSoundEnabled = !isSoundEnabled;
              });
            },
          ),
          Switch(
            value: isGujarati,
            onChanged: (value) {
              setState(() {
                isGujarati = value;
              });
            },
            activeColor: Colors.green,
            inactiveThumbColor: Colors.grey,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  getDisplayText(input),
                  style: const TextStyle(fontSize: 24, color: Colors.white54),
                ),
                Text(
                  getDisplayText(output),
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.backspace),
                  onPressed: () {
                    buttonPressed("⌫");
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "History",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            historyList.clear();
                          });
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: ListView.builder(
                        itemCount: historyList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: ListTile(
                              title: Text(
                                historyList[index],
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  buildButton("C", Colors.orange),
                  buildButton("(", Colors.blueGrey),
                  buildButton(")", Colors.blueGrey),
                  buildButton("÷", Colors.blueGrey),
                ],
              ),
              Row(
                children: [
                  buildButton("7", Colors.grey),
                  buildButton("8", Colors.grey),
                  buildButton("9", Colors.grey),
                  buildButton("×", Colors.blueGrey),
                ],
              ),
              Row(
                children: [
                  buildButton("4", Colors.grey),
                  buildButton("5", Colors.grey),
                  buildButton("6", Colors.grey),
                  buildButton("-", Colors.blueGrey),
                ],
              ),
              Row(
                children: [
                  buildButton("1", Colors.grey),
                  buildButton("2", Colors.grey),
                  buildButton("3", Colors.grey),
                  buildButton("+", Colors.blueGrey),
                ],
              ),
              Row(
                children: [
                  buildButton("%", Colors.blueGrey),
                  buildButton("0", Colors.grey),
                  buildButton(".", Colors.grey),
                  buildButton("=", Colors.green),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
