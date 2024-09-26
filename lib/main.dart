import 'package:assistants/Views/AssistantView.dart';
import 'package:assistants/services/OpenAIService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ViewModels/AssistantViewModel.dart';
import 'env/env.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AssistantViewModel(OpenAIService(Env.apiKey)),
        ),
      ],
      child: MaterialApp(
        title: 'OpenAI Assistant Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AssistantView(),
      ),
    );
  }
}

