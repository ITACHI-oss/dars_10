import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:dars_10/core/widget/task_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// 1. Stringni teskari aylantirish
void reverseStringIsolate(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  receivePort.listen((message) {
    if (message is String) {
      final reversed = message.split('').reversed.join();
      sendPort.send(reversed);
    }
    receivePort.close();
  });
}

// 2. Ro‘yxatdagi sonlar yig‘indisi
void sumListIsolate(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  receivePort.listen((message) {
    if (message is List<int>) {
      final sum = message.reduce((a, b) => a + b);
      sendPort.send(sum);
    }
    receivePort.close();
  });
}

// 3. 100 milliongacha sonlar yig‘indisi
void sumToHundredMillionIsolate(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  receivePort.listen((message) {
    if (message is int) {
      BigInt sum = BigInt.zero;
      for (int i = 1; i <= message; i++) {
        sum += BigInt.from(i);
      }
      sendPort.send(sum.toString());
    }
    receivePort.close();
  });
}

// 4. Fibonacci sonini hisoblash
void fibonacciIsolate(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  receivePort.listen((message) {
    if (message is int) {
      BigInt a = BigInt.zero, b = BigInt.one;
      for (int i = 2; i <= message; i++) {
        final temp = a + b;
        a = b;
        b = temp;
      }
      sendPort.send(b.toString());
    }
    receivePort.close();
  });
}

// 5. Raqamlar ro‘yxatini kvadratga ko‘paytirish
void squareListIsolate(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  receivePort.listen((message) {
    if (message is List<int>) {
      final squared = message.map((e) => e * e).toList();
      sendPort.send(squared);
    }
    receivePort.close();
  });
}

// 6. Takroriy sonlarni olib tashlash
void removeDuplicatesIsolate(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  receivePort.listen((message) {
    if (message is List<int>) {
      final unique = message.toSet().toList();
      sendPort.send(unique);
    }
    receivePort.close();
  });
}

// 7. So‘zlar sonini hisoblash
void countWordsIsolate(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  receivePort.listen((message) {
    if (message is String) {
      final words = message.toLowerCase().split(' ');
      final wordCount = <String, int>{};
      for (var word in words) {
        wordCount[word] = (wordCount[word] ?? 0) + 1;
      }
      sendPort.send(wordCount);
    }
    receivePort.close();
  });
}

// 8. Matndan raqamlarni ajratib olish
void extractNumbersIsolate(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  receivePort.listen((message) {
    if (message is String) {
      final numbers =
          RegExp(
            r'\d+',
          ).allMatches(message).map((m) => int.parse(m.group(0)!)).toList();
      sendPort.send(numbers);
    }
    receivePort.close();
  });
}

// 9. Matematik ifodani hisoblash (oddiy + va * uchun)
void evaluateExpressionIsolate(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  receivePort.listen((message) {
    if (message is String) {
      final tokens = message.split(' ');
      int result = int.parse(tokens[0]);
      for (int i = 1; i < tokens.length; i += 2) {
        final op = tokens[i];
        final num = int.parse(tokens[i + 1]);
        if (op == '+') {
          result += num;
        } else if (op == '*') {
          result *= num;
        }
      }
      sendPort.send(result);
    }
    receivePort.close();
  });
}

// 10. Rasmni base64 formatga o‘tkazish
void imageToBase64Isolate(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  receivePort.listen((message) async {
    if (message is String) {
      final file = File(message);
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);
      sendPort.send(base64String);
    }
    receivePort.close();
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;
  String? _base64Image;

  // 1. Stringni teskari aylantirish uchun Isolate
  Future<void> _runReverseStringIsolate(String input) async {
    setState(() {
      _isLoading = true;
    });

    final receivePort = ReceivePort();
    await Isolate.spawn(reverseStringIsolate, receivePort.sendPort);

    SendPort? isolateSendPort;
    receivePort.listen((message) {
      if (message is SendPort) {
        isolateSendPort = message;
        isolateSendPort!.send(input);
      } else {
        print('Natija (Stringni teskari aylantirish): $message');
        setState(() {
          _isLoading = false;
        });
        receivePort.close();
      }
    });
  }

  // 2. Ro‘yxatdagi sonlar yig‘indisi uchun Isolate
  Future<void> _runSumListIsolate(List<int> input) async {
    setState(() {
      _isLoading = true;
    });

    final receivePort = ReceivePort();
    await Isolate.spawn(sumListIsolate, receivePort.sendPort);

    SendPort? isolateSendPort;
    receivePort.listen((message) {
      if (message is SendPort) {
        isolateSendPort = message;
        isolateSendPort!.send(input);
      } else {
        print('Natija (Ro‘yxatdagi sonlar yig‘indisi): $message');
        setState(() {
          _isLoading = false;
        });
        receivePort.close();
      }
    });
  }

  // 3. 100 milliongacha yig‘indi uchun Isolate
  Future<void> _runSumToHundredMillionIsolate(int input) async {
    setState(() {
      _isLoading = true;
    });

    final receivePort = ReceivePort();
    await Isolate.spawn(sumToHundredMillionIsolate, receivePort.sendPort);

    SendPort? isolateSendPort;
    receivePort.listen((message) {
      if (message is SendPort) {
        isolateSendPort = message;
        isolateSendPort!.send(input);
      } else {
        print('Natija (100 milliongacha yig‘indi): $message');
        setState(() {
          _isLoading = false;
        });
        receivePort.close();
      }
    });
  }

  // 4. Fibonacci soni uchun Isolate
  Future<void> _runFibonacciIsolate(int input) async {
    setState(() {
      _isLoading = true;
    });

    final receivePort = ReceivePort();
    await Isolate.spawn(fibonacciIsolate, receivePort.sendPort);

    SendPort? isolateSendPort;
    receivePort.listen((message) {
      if (message is SendPort) {
        isolateSendPort = message;
        isolateSendPort!.send(input);
      } else {
        print('Natija (Fibonacci soni): $message');
        setState(() {
          _isLoading = false;
        });
        receivePort.close();
      }
    });
  }

  // 5. Raqamlarni kvadratga ko‘paytirish uchun Isolate
  Future<void> _runSquareListIsolate(List<int> input) async {
    setState(() {
      _isLoading = true;
    });

    final receivePort = ReceivePort();
    await Isolate.spawn(squareListIsolate, receivePort.sendPort);

    SendPort? isolateSendPort;
    receivePort.listen((message) {
      if (message is SendPort) {
        isolateSendPort = message;
        isolateSendPort!.send(input);
      } else {
        print('Natija (Raqamlarni kvadratga ko‘paytirish): $message');
        setState(() {
          _isLoading = false;
        });
        receivePort.close();
      }
    });
  }

  // 6. Takroriy sonlarni olib tashlash uchun Isolate
  Future<void> _runRemoveDuplicatesIsolate(List<int> input) async {
    setState(() {
      _isLoading = true;
    });

    final receivePort = ReceivePort();
    await Isolate.spawn(removeDuplicatesIsolate, receivePort.sendPort);

    SendPort? isolateSendPort;
    receivePort.listen((message) {
      if (message is SendPort) {
        isolateSendPort = message;
        isolateSendPort!.send(input);
      } else {
        print('Natija (Takroriy sonlarni olib tashlash): $message');
        setState(() {
          _isLoading = false;
        });
        receivePort.close();
      }
    });
  }

  // 7. So‘zlar sonini hisoblash uchun Isolate
  Future<void> _runCountWordsIsolate(String input) async {
    setState(() {
      _isLoading = true;
    });

    final receivePort = ReceivePort();
    await Isolate.spawn(countWordsIsolate, receivePort.sendPort);

    SendPort? isolateSendPort;
    receivePort.listen((message) {
      if (message is SendPort) {
        isolateSendPort = message;
        isolateSendPort!.send(input);
      } else {
        print('Natija (So‘zlar sonini hisoblash): $message');
        setState(() {
          _isLoading = false;
        });
        receivePort.close();
      }
    });
  }

  // 8. Raqamlarni ajratib olish uchun Isolate
  Future<void> _runExtractNumbersIsolate(String input) async {
    setState(() {
      _isLoading = true;
    });

    final receivePort = ReceivePort();
    await Isolate.spawn(extractNumbersIsolate, receivePort.sendPort);

    SendPort? isolateSendPort;
    receivePort.listen((message) {
      if (message is SendPort) {
        isolateSendPort = message;
        isolateSendPort!.send(input);
      } else {
        print('Natija (Raqamlarni ajratib olish): $message');
        setState(() {
          _isLoading = false;
        });
        receivePort.close();
      }
    });
  }

  // 9. Matematik ifodani hisoblash uchun Isolate
  Future<void> _runEvaluateExpressionIsolate(String input) async {
    setState(() {
      _isLoading = true;
    });

    final receivePort = ReceivePort();
    await Isolate.spawn(evaluateExpressionIsolate, receivePort.sendPort);

    SendPort? isolateSendPort;
    receivePort.listen((message) {
      if (message is SendPort) {
        isolateSendPort = message;
        isolateSendPort!.send(input);
      } else {
        print('Natija (Matematik ifodani hisoblash): $message');
        setState(() {
          _isLoading = false;
        });
        receivePort.close();
      }
    });
  }

  // 10. Rasmni tanlab base64 ga o‘tkazish uchun Isolate
  Future<void> _runImageToBase64Isolate() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isLoading = true;
        _base64Image = null;
      });

      final receivePort = ReceivePort();
      await Isolate.spawn(imageToBase64Isolate, receivePort.sendPort);

      SendPort? isolateSendPort;
      receivePort.listen((message) {
        if (message is SendPort) {
          isolateSendPort = message;
          isolateSendPort!.send(pickedFile.path);
        } else {
          setState(() {
            _isLoading = false;
            _base64Image = message.toString();
          });
          receivePort.close();
        }
      });
    }
  }

  final List<Map<String, dynamic>> tasks = [
    {
      'name': '1. Stringni teskari aylantirish',
      'function': reverseStringIsolate,
      'input': 'Flutter',
      'runner': null,
    },
    {
      'name': '2. Ro‘yxatdagi sonlar yig‘indisi',
      'function': sumListIsolate,
      'input': [1, 2, 3, 4, 5],
      'runner': null,
    },
    {
      'name': '3. 100 milliongacha yig‘indi',
      'function': sumToHundredMillionIsolate,
      'input': 100000000,
      'runner': null,
    },
    {
      'name': '4. Fibonacci soni',
      'function': fibonacciIsolate,
      'input': 40,
      'runner': null,
    },
    {
      'name': '5. Raqamlarni kvadratga ko‘paytirish',
      'function': squareListIsolate,
      'input': [1, 2, 3],
      'runner': null,
    },
    {
      'name': '6. Takroriy sonlarni olib tashlash',
      'function': removeDuplicatesIsolate,
      'input': [1, 2, 2, 3, 3, 3, 4],
      'runner': null,
    },
    {
      'name': '7. So‘zlar sonini hisoblash',
      'function': countWordsIsolate,
      'input': 'Salom dunyo salom',
      'runner': null,
    },
    {
      'name': '8. Raqamlarni ajratib olish',
      'function': extractNumbersIsolate,
      'input': 'Salom Dunyo09',
      'runner': null,
    },
    {
      'name': '9. Matematik ifodani hisoblash',
      'function': evaluateExpressionIsolate,
      'input': '10 + 5 * 2',
      'runner': null,
    },
    {
      'name': '10. Rasmni base64ga o‘tkazish',
      'function': imageToBase64Isolate,
      'input': null,
      'runner': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    tasks[0]['runner'] = _runReverseStringIsolate;
    tasks[1]['runner'] = _runSumListIsolate;
    tasks[2]['runner'] = _runSumToHundredMillionIsolate;
    tasks[3]['runner'] = _runFibonacciIsolate;
    tasks[4]['runner'] = _runSquareListIsolate;
    tasks[5]['runner'] = _runRemoveDuplicatesIsolate;
    tasks[6]['runner'] = _runCountWordsIsolate;
    tasks[7]['runner'] = _runExtractNumbersIsolate;
    tasks[8]['runner'] = _runEvaluateExpressionIsolate;
    tasks[8]['runner'] = _runImageToBase64Isolate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Isolate Vazifalari",
          style: TextStyle(
            color: Colors.green,
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ...tasks.map(
              (task) => TaskButton(
                text: task['name'],
                onPressed:
                    _isLoading
                        ? null
                        : () {
                          final runner = task['runner'];
                          final input = task['input'];
                          if (input == null) {
                            runner();
                          } else {
                            runner(input);
                          }
                        },
              ),
            ),
            SizedBox(height: 30),

            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_base64Image != null) ...[
              Text(
                "Base64 ga o'girilgan rasm:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 10),
              Image.memory(base64Decode(_base64Image!), height: 200),
            ],
          ],
        ),
      ),
    );
  }
}
