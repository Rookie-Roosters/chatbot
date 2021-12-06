import 'dart:math';

import 'package:chatbot/models/answer.dart';
import 'package:chatbot/models/question.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatBot',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('ChatBot'),
        ),
        body: const SafeArea(
          child: SingleChildScrollView(
            child: ChatBot(),
          ),
        ),
      ),
    );
  }
}

class ChatBot extends StatefulWidget {
  const ChatBot({Key? key}) : super(key: key);

  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  bool add = false, exist = false;
  Question question = Question(id: 0, text: '');
  Answer answer = Answer(question: null, text: '');
  final questionController = TextEditingController(text: '');
  final answerController = TextEditingController(text: '');

  Future<void> ask() async {
    if (formStateKey.currentState!.validate()) {
      formStateKey.currentState!.save();
      final int index = await Question.getIdByText(question.text.toLowerCase());
      if (index == -1) {
        setState(() {
          exist = true;
        });
      } else {
        final List<Answer> answers = await Answer.getByQuestion(index);
        answer = answers[Random().nextInt(answers.length)];
        setState(() {
          answerController.text = answer.text;
        });
      }
    }
  }

  Future<void> addAnswer() async {
    if (formStateKey.currentState!.validate()) {
      formStateKey.currentState!.save();
      final int index = await Question.getIdByText(question.text.toLowerCase());
      if (index == -1) {
        await question.add();
      }
      answer.question = await Question.getById(index);
      answer.add();
      setState(() {
        add = false;
        exist = false;
        answerController.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formStateKey,
      autovalidateMode: AutovalidateMode.always,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: questionController,
              decoration: const InputDecoration(
                labelText: 'Pregunta',
              ),
              validator: (value) =>
                  value!.length > 3 ? null : 'Pregunta no válida',
              onSaved: (value) => question.text = value ?? '',
              onChanged: (value) {
                if (add || answer.text != '' || exist) {
                  setState(() {
                    add = false;
                    exist = false;
                    answer = Answer(question: null, text: '');
                    answerController.text = '';
                  });
                }
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: answerController,
              decoration: const InputDecoration(
                labelText: 'Respuesta',
              ),
              validator: (value) => add
                  ? (value!.length > 3 ? null : 'Respuesta no válida')
                  : null,
              onSaved: (value) => answer.text = value ?? '',
              onChanged: (value) {
                if (!add) {
                  setState(() {
                    add = true;
                  });
                } else if(value == '') {
                  setState(() {
                    add = false;
                  });
                }
              },
            ),
            Text(exist
                ? 'Aún no existe una respuesta a tu pregunta, añade una respuesta'
                : ''),
            const Divider(
              height: 32.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      ask();
                    },
                    child: const Text('Preguntar')),
                ElevatedButton(
                    onPressed: () {
                      addAnswer();
                    },
                    child: const Text('Añadir respuesta')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
