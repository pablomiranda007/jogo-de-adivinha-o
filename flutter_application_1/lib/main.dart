import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const AdivinhacaoApp());
}

class AdivinhacaoApp extends StatelessWidget {
  const AdivinhacaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo de Adivinhação',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const JogoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class JogoPage extends StatefulWidget {
  const JogoPage({super.key});

  @override
  State<JogoPage> createState() => _JogoPageState();
}

class _JogoPageState extends State<JogoPage> {
  int min = 0;
  int max = 100;
  int? palpite;
  int tentativas = 0;
  final Random random = Random();

  void gerarPalpite() {
    if (min > max) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Algo deu errado! Reinicie o jogo.')),
      );
      return;
    }

    setState(() {
      palpite = min + random.nextInt(max - min + 1);
      tentativas++;
    });
  }

  void reiniciarJogo() {
    setState(() {
      min = 0;
      max = 100;
      tentativas = 0;
      palpite = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jogo de Adivinhação')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: palpite == null
              ? ElevatedButton(
                  onPressed: gerarPalpite,
                  child: const Text('Começar o jogo'),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Seu número é $palpite?',
                      style: const TextStyle(fontSize: 28),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              min = palpite! + 1;
                              gerarPalpite();
                            });
                          },
                          child: const Text('Maior 🔼'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              max = palpite! - 1;
                              gerarPalpite();
                            });
                          },
                          child: const Text('Menor 🔽'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('🎉 Acertamos!'),
                                content: Text(
                                  'Número $palpite encontrado em $tentativas tentativas!',
                                  textAlign: TextAlign.center,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      reiniciarJogo();
                                    },
                                    child: const Text('Jogar novamente'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text('Acertou ✅'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text('Tentativas: $tentativas'),
                  ],
                ),
        ),
      ),
    );
  }
}
