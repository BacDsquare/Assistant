import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModels/AssistantViewModel.dart';

class AssistantView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AssistantViewState();
}

class _AssistantViewState extends State<AssistantView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<AssistantViewModel>(context, listen: false);
    viewModel.createThread();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AssistantViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('GBU Assistant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter your message'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                viewModel
                    .addMessage('user', _controller.text)
                    .then((_) => viewModel.runAssistant());
              },
              child: Text('Send Message'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.messages.length,
                itemBuilder: (context, index) {
                  final message = viewModel.messages[index];
                  return ListTile(
                    title: Text(message.role),
                    subtitle: Text(message.content[0].text.value, style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    )),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
