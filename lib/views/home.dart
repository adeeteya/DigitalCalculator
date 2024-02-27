import 'package:digital_calculator/constants.dart';
import 'package:digital_calculator/intents.dart';
import 'package:digital_calculator/widgets/calculator_button.dart';
import 'package:digital_calculator/widgets/clear_button.dart';
import 'package:digital_calculator/widgets/digital_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:math_expressions/math_expressions.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String expressionText = "0";
  int maxChars = 50;
  bool scrollToMinExtent = false;
  final ScrollController resultScrollController = ScrollController();
  final GlobalKey digit0Key = GlobalKey();
  final GlobalKey digit1Key = GlobalKey();
  final GlobalKey digit2Key = GlobalKey();
  final GlobalKey digit3Key = GlobalKey();
  final GlobalKey digit4Key = GlobalKey();
  final GlobalKey digit5Key = GlobalKey();
  final GlobalKey digit6Key = GlobalKey();
  final GlobalKey digit7Key = GlobalKey();
  final GlobalKey digit8Key = GlobalKey();
  final GlobalKey digit9Key = GlobalKey();
  final GlobalKey commaKey = GlobalKey();
  final GlobalKey percentageKey = GlobalKey();
  final GlobalKey clearKey = GlobalKey();

  int getMaxChars(double width) {
    late int numLines;
    TextSpan span = const TextSpan(
      text: "88888888888888888888888888888888888888888888888888",
      style: TextStyle(
        color: onyx,
        fontSize: 35,
        fontFamily: "Digital Numbers",
      ),
    );
    late TextPainter tp;
    do {
      span = TextSpan(
        text: span.text?.substring(1),
        style: const TextStyle(
          color: onyx,
          fontSize: 35,
          fontFamily: "Digital Numbers",
        ),
      );
      tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout(maxWidth: width);
      numLines = tp.computeLineMetrics().length;
    } while (numLines > 1);
    return span.text?.length ?? 50;
  }

  void scrollBack() {
    if (scrollToMinExtent) {
      resultScrollController.jumpTo(
        resultScrollController.position.minScrollExtent,
      );
      scrollToMinExtent = false;
    }
  }

  void setExpressionText(String text) {
    scrollBack();
    setState(() {
      if (expressionText == "0" || expressionText == "ERR") {
        if (text == "+" || text == "x" || text == "/" || text == "%") {
          return;
        }
        if (text == ".") {
          expressionText = "0.";
          return;
        }
        expressionText = text;
      } else {
        expressionText += text;
      }
    });
  }

  void compute() {
    if (expressionText == "0" &&
        expressionText == "ERR" &&
        expressionText.contains(RegExp("^[0-9]+\$"))) {
      return;
    }
    try {
      Parser p = Parser();
      Expression exp =
          p.parse(expressionText.replaceAll("x", "*").replaceAll("%", "/100"));
      double result = exp.evaluate(EvaluationType.REAL, ContextModel());
      setState(() {
        if (result == result.toInt()) {
          expressionText = result.toInt().toString();
        } else {
          expressionText = result.toString();
          if (expressionText.split(".").elementAt(1).length > 8) {
            expressionText = result.toStringAsFixed(8);
            expressionText =
                expressionText.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
          }
        }
      });
      if (expressionText.length > maxChars) {
        resultScrollController.animateTo(
          resultScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
        scrollToMinExtent = true;
      }
    } catch (e) {
      setState(() {
        expressionText = "ERR";
      });
    }
  }

  void switchLastNumber() {
    scrollBack();
    if (expressionText == "0" || expressionText == "ERR") {
      return;
    }
    try {
      List numbers = expressionText.split(RegExp((r"[x|\+|\-|/]")));
      int lastNumIndex = expressionText.lastIndexOf(numbers.last);
      if (lastNumIndex != 0) {
        if (expressionText[lastNumIndex - 1] == "-") {
          if (lastNumIndex == 1) {
            expressionText = expressionText.substring(1);
          } else if (expressionText[lastNumIndex - 2] == "/" ||
              expressionText[lastNumIndex - 2] == "x") {
            expressionText =
                "${expressionText.substring(0, lastNumIndex - 1)}${expressionText.substring(lastNumIndex, expressionText.length)}";
          } else {
            expressionText =
                "${expressionText.substring(0, lastNumIndex - 1)}+${expressionText.substring(lastNumIndex, expressionText.length)}";
          }
        } else if (expressionText[lastNumIndex - 1] == "+") {
          expressionText =
              "${expressionText.substring(0, lastNumIndex - 1)}-${expressionText.substring(lastNumIndex, expressionText.length)}";
        } else {
          expressionText =
              "${expressionText.substring(0, lastNumIndex)}-${expressionText.substring(lastNumIndex, expressionText.length)}";
        }
      } else {
        expressionText =
            "${expressionText.substring(0, lastNumIndex)}-${expressionText.substring(lastNumIndex, expressionText.length)}";
      }
      setState(() {});
    } catch (e) {
      setState(() {
        expressionText = "ERR";
      });
    }
  }

  void deleteCharacter() {
    if (expressionText == "0" || expressionText == "ERR") {
      return;
    }
    setState(() {
      if (expressionText.length == 1) {
        expressionText = "0";
      } else {
        expressionText = expressionText.substring(0, expressionText.length - 1);
      }
    });
  }

  void allClear() {
    scrollBack();
    setState(() {
      expressionText = "0";
    });
  }

  Future simulateButtonPress(RenderBox renderBox) async {
    Offset buttonOffset = Offset(renderBox.localToGlobal(Offset.zero).dx + 10,
        renderBox.localToGlobal(Offset.zero).dy + 10);
    GestureBinding.instance.handlePointerEvent(PointerDownEvent(
      position: buttonOffset,
    ));
    await Future.delayed(const Duration(milliseconds: 175));
    GestureBinding.instance.handlePointerEvent(PointerUpEvent(
      position: buttonOffset,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.digit0): const Digit0Intent(),
        LogicalKeySet(LogicalKeyboardKey.digit1): const Digit1Intent(),
        LogicalKeySet(LogicalKeyboardKey.digit2): const Digit2Intent(),
        LogicalKeySet(LogicalKeyboardKey.digit3): const Digit3Intent(),
        LogicalKeySet(LogicalKeyboardKey.digit4): const Digit4Intent(),
        LogicalKeySet(LogicalKeyboardKey.digit5): const Digit5Intent(),
        LogicalKeySet(LogicalKeyboardKey.digit6): const Digit6Intent(),
        LogicalKeySet(LogicalKeyboardKey.digit7): const Digit7Intent(),
        LogicalKeySet(LogicalKeyboardKey.digit8): const Digit8Intent(),
        LogicalKeySet(LogicalKeyboardKey.digit9): const Digit9Intent(),
        const CharacterActivator("+"): const AdditionIntent(),
        const CharacterActivator("*"): const MultiplicationIntent(),
        const CharacterActivator("x"): const MultiplicationIntent(),
        const CharacterActivator("-"): const SubtractionIntent(),
        const CharacterActivator("/"): const DivisionIntent(),
        const CharacterActivator("%"): const PercentIntent(),
        LogicalKeySet(LogicalKeyboardKey.backspace): const BackSpaceIntent(),
        LogicalKeySet(LogicalKeyboardKey.period): const PeriodIntent(),
        LogicalKeySet(LogicalKeyboardKey.comma): const PeriodIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): const ComputeIntent(),
        LogicalKeySet(LogicalKeyboardKey.equal): const ComputeIntent(),
        LogicalKeySet(LogicalKeyboardKey.escape): const BackSpaceIntent(),
        LogicalKeySet(LogicalKeyboardKey.delete): const BackSpaceIntent(),
        const CharacterActivator("c"): const AllClearIntent(),
      },
      child: Actions(
        actions: {
          Digit0Intent: CallbackAction<Digit0Intent>(
              onInvoke: (intent) => simulateButtonPress(
                  digit0Key.currentContext?.findRenderObject() as RenderBox)),
          Digit1Intent: CallbackAction<Digit1Intent>(
              onInvoke: (intent) => simulateButtonPress(
                  digit1Key.currentContext?.findRenderObject() as RenderBox)),
          Digit2Intent: CallbackAction<Digit2Intent>(
              onInvoke: (intent) => simulateButtonPress(
                  digit2Key.currentContext?.findRenderObject() as RenderBox)),
          Digit3Intent: CallbackAction<Digit3Intent>(
              onInvoke: (intent) => simulateButtonPress(
                  digit3Key.currentContext?.findRenderObject() as RenderBox)),
          Digit4Intent: CallbackAction<Digit4Intent>(
              onInvoke: (intent) => simulateButtonPress(
                  digit4Key.currentContext?.findRenderObject() as RenderBox)),
          Digit5Intent: CallbackAction<Digit5Intent>(
              onInvoke: (intent) => simulateButtonPress(
                  digit5Key.currentContext?.findRenderObject() as RenderBox)),
          Digit6Intent: CallbackAction<Digit6Intent>(
              onInvoke: (intent) => simulateButtonPress(
                  digit6Key.currentContext?.findRenderObject() as RenderBox)),
          Digit7Intent: CallbackAction<Digit7Intent>(
              onInvoke: (intent) => simulateButtonPress(
                  digit7Key.currentContext?.findRenderObject() as RenderBox)),
          Digit8Intent: CallbackAction<Digit8Intent>(
              onInvoke: (intent) => simulateButtonPress(
                  digit8Key.currentContext?.findRenderObject() as RenderBox)),
          Digit9Intent: CallbackAction<Digit9Intent>(
              onInvoke: (intent) => simulateButtonPress(
                  digit9Key.currentContext?.findRenderObject() as RenderBox)),
          AdditionIntent: CallbackAction<AdditionIntent>(
              onInvoke: (intent) => setExpressionText("+")),
          SubtractionIntent: CallbackAction<SubtractionIntent>(
              onInvoke: (intent) => setExpressionText("-")),
          MultiplicationIntent: CallbackAction<MultiplicationIntent>(
              onInvoke: (intent) => setExpressionText("x")),
          DivisionIntent: CallbackAction<DivisionIntent>(
              onInvoke: (intent) => setExpressionText("/")),
          PercentIntent: CallbackAction<PercentIntent>(
              onInvoke: (intent) => simulateButtonPress(
                  percentageKey.currentContext?.findRenderObject()
                      as RenderBox)),
          PeriodIntent: CallbackAction<PeriodIntent>(
              onInvoke: (intent) => simulateButtonPress(
                  commaKey.currentContext?.findRenderObject() as RenderBox)),
          BackSpaceIntent: CallbackAction<BackSpaceIntent>(
              onInvoke: (intent) => deleteCharacter()),
          AllClearIntent:
              CallbackAction<AllClearIntent>(onInvoke: (intent) => allClear()),
          ComputeIntent:
              CallbackAction<ComputeIntent>(onInvoke: (intent) => compute()),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                //If The Layout is in Landscape Mode
                if (constraints.maxWidth > constraints.maxHeight) {
                  //Landscape Layout
                  double widthPerButton = (constraints.maxWidth - 100) / 8.1;
                  maxChars = getMaxChars(widthPerButton * 5 + 45) - 1;
                  return SafeArea(
                    minimum: const EdgeInsets.symmetric(horizontal: 5),
                    left: false,
                    right: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: widthPerButton * 5.5,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [pastelGray, laurelGreen],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    inset: true,
                                  ),
                                ],
                              ),
                              child: DigitalText(
                                text: expressionText,
                                scrollController: resultScrollController,
                                initialMaxChars: maxChars,
                              ),
                            ),
                            CalculatorButton(
                              key: digit7Key,
                              width: widthPerButton,
                              text: "7",
                              onTap: () => setExpressionText("7"),
                            ),
                            CalculatorButton(
                              key: digit8Key,
                              width: widthPerButton,
                              text: "8",
                              onTap: () => setExpressionText("8"),
                            ),
                            CalculatorButton(
                              key: digit9Key,
                              width: widthPerButton,
                              text: "9",
                              onTap: () => setExpressionText("9"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ClearButton(
                              key: clearKey,
                              width: widthPerButton,
                              onTap: deleteCharacter,
                              onLongPress: allClear,
                            ),
                            CalculatorButton(
                              width: widthPerButton,
                              text: "+",
                              isBlue: true,
                              onTap: () => setExpressionText("+"),
                            ),
                            CalculatorButton(
                              width: widthPerButton,
                              text: "-",
                              isBlue: true,
                              onTap: () => setExpressionText("-"),
                            ),
                            CalculatorButton(
                              width: widthPerButton,
                              text: "X",
                              isBlue: true,
                              onTap: () => setExpressionText("x"),
                            ),
                            CalculatorButton(
                              width: widthPerButton,
                              text: "÷",
                              isBlue: true,
                              onTap: () => setExpressionText("/"),
                            ),
                            CalculatorButton(
                              key: digit4Key,
                              width: widthPerButton,
                              text: "4",
                              onTap: () => setExpressionText("4"),
                            ),
                            CalculatorButton(
                              key: digit5Key,
                              width: widthPerButton,
                              text: "5",
                              onTap: () => setExpressionText("5"),
                            ),
                            CalculatorButton(
                              key: digit6Key,
                              width: widthPerButton,
                              text: "6",
                              onTap: () => setExpressionText("6"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CalculatorButton(
                              width: widthPerButton,
                              text: "=",
                              isBlue: true,
                              onTap: compute,
                            ),
                            CalculatorButton(
                              width: widthPerButton,
                              text: "+/-",
                              onTap: switchLastNumber,
                            ),
                            CalculatorButton(
                              key: percentageKey,
                              width: widthPerButton,
                              text: "%",
                              onTap: () => setExpressionText("%"),
                            ),
                            CalculatorButton(
                              key: commaKey,
                              width: widthPerButton,
                              text: ",",
                              onTap: () => setExpressionText("."),
                            ),
                            CalculatorButton(
                              key: digit0Key,
                              width: widthPerButton,
                              text: "0",
                              onTap: () => setExpressionText("0"),
                            ),
                            CalculatorButton(
                              key: digit1Key,
                              width: widthPerButton,
                              text: "1",
                              onTap: () => setExpressionText("1"),
                            ),
                            CalculatorButton(
                              key: digit2Key,
                              width: widthPerButton,
                              text: "2",
                              onTap: () => setExpressionText("2"),
                            ),
                            CalculatorButton(
                              key: digit3Key,
                              width: widthPerButton,
                              text: "3",
                              onTap: () => setExpressionText("3"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                //If The Layout is in Portrait Mode
                else {
                  double widthPerButton = (constraints.maxWidth - 50) / 4.4;
                  maxChars =
                      getMaxChars(MediaQuery.of(context).size.width - 20) - 2;
                  return SafeArea(
                    child: Column(
                      children: [
                        const Spacer(),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                (MediaQuery.of(context).platformBrightness ==
                                        Brightness.light)
                                    ? pastelGray
                                    : laurelGreen,
                                laurelGreen,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 10,
                                inset: true,
                              ),
                            ],
                          ),
                          child: DigitalText(
                            text: expressionText,
                            scrollController: resultScrollController,
                            initialMaxChars: maxChars,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ClearButton(
                              key: clearKey,
                              width: widthPerButton,
                              onTap: deleteCharacter,
                              onLongPress: allClear,
                            ),
                            CalculatorButton(
                              width: widthPerButton,
                              text: "+/-",
                              onTap: switchLastNumber,
                            ),
                            CalculatorButton(
                              key: percentageKey,
                              width: widthPerButton,
                              text: "%",
                              onTap: () => setExpressionText("%"),
                            ),
                            CalculatorButton(
                              width: widthPerButton,
                              text: "÷",
                              isBlue: true,
                              onTap: () => setExpressionText("/"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CalculatorButton(
                              key: digit7Key,
                              width: widthPerButton,
                              text: "7",
                              onTap: () => setExpressionText("7"),
                            ),
                            CalculatorButton(
                              key: digit8Key,
                              width: widthPerButton,
                              text: "8",
                              onTap: () => setExpressionText("8"),
                            ),
                            CalculatorButton(
                              key: digit9Key,
                              width: widthPerButton,
                              text: "9",
                              onTap: () => setExpressionText("9"),
                            ),
                            CalculatorButton(
                              width: widthPerButton,
                              text: "X",
                              isBlue: true,
                              onTap: () => setExpressionText("x"),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CalculatorButton(
                              key: digit4Key,
                              width: widthPerButton,
                              text: "4",
                              onTap: () => setExpressionText("4"),
                            ),
                            CalculatorButton(
                              key: digit5Key,
                              width: widthPerButton,
                              text: "5",
                              onTap: () => setExpressionText("5"),
                            ),
                            CalculatorButton(
                              key: digit6Key,
                              width: widthPerButton,
                              text: "6",
                              onTap: () => setExpressionText("6"),
                            ),
                            CalculatorButton(
                              width: widthPerButton,
                              text: "-",
                              isBlue: true,
                              onTap: () => setExpressionText("-"),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CalculatorButton(
                              key: digit1Key,
                              width: widthPerButton,
                              text: "1",
                              onTap: () => setExpressionText("1"),
                            ),
                            CalculatorButton(
                              key: digit2Key,
                              width: widthPerButton,
                              text: "2",
                              onTap: () => setExpressionText("2"),
                            ),
                            CalculatorButton(
                              key: digit3Key,
                              width: widthPerButton,
                              text: "3",
                              onTap: () => setExpressionText("3"),
                            ),
                            CalculatorButton(
                              width: widthPerButton,
                              text: "+",
                              isBlue: true,
                              onTap: () => setExpressionText("+"),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CalculatorButton(
                              key: digit0Key,
                              width: widthPerButton * 2 + 10,
                              isDoubleTile: true,
                              text: "0",
                              onTap: () => setExpressionText("0"),
                            ),
                            CalculatorButton(
                              key: commaKey,
                              width: widthPerButton,
                              text: ",",
                              onTap: () => setExpressionText("."),
                            ),
                            CalculatorButton(
                              width: widthPerButton,
                              text: "=",
                              isBlue: true,
                              onTap: compute,
                            )
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
