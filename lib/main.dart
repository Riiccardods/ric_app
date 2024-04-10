import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enviar Dados via API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  String _responseMessage = '';
  bool _isLoading = false;

  void _sendData() async {
    // Verifica se todos os campos estão preenchidos
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _subjectController.text.isEmpty ||
        _messageController.text.isEmpty) {
      setState(() {
        _responseMessage = 'Por favor, preencha todos os campos.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    var url = Uri.parse('https://ricardocs.dev:84/api/MensagemContato');
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': _nameController.text,
          'email': _emailController.text,
          'assunto': _subjectController.text,
          'mensagem': _messageController.text,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          _responseMessage = 'Mensagem enviada com sucesso.';
          _clearFields(); // Limpa todos os campos após o envio bem-sucedido
        });
      } else {
        setState(() {
          _responseMessage = 'Erro ao enviar mensagem.';
        });
      }
    } catch (error) {
      setState(() {
        _responseMessage = 'Erro ao enviar mensagem: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Função para limpar todos os campos
  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _subjectController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enviar Dados via API'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome',
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: 'Assunto',
              ),
            ),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Mensagem',
              ),
            ),
            SizedBox(height: 20.0),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _sendData,
                    child: Text('Enviar'),
                  ),
            SizedBox(height: 20.0),
            Text(
              _responseMessage,
              style: TextStyle(
                fontSize: 18.0,
                color: _responseMessage.startsWith('Erro') || _responseMessage.startsWith('Por favor') ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
