import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ScreenThreeAddTask extends StatelessWidget {
  const ScreenThreeAddTask({super.key});

  static const typeList = [
    'Personal Projects',
    'Other Projects',
    'Side Projects'
  ];

  static const priorityList = ['Needs Done', 'Wants Done', 'Other wants Done'];

  static const timeFrameList = [
    '3 days',
    '1 week',
    '1 month',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        foregroundColor: Colors.grey[800],
        leading: const Icon(Icons.arrow_back),
        backgroundColor: Colors.grey[50],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Form(
          child: ListView(
            shrinkWrap: true,
            reverse: true,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Add New Task',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),

              //Textfield section
              const SizedBox(height: 15),
              const LabeledTextField(label: 'Task', hintText: 'Wireframing'),
              const LabeledDropdownButton(label: 'Type', menus: typeList),
              const LabeledDropdownButton(
                  label: 'Priority', menus: priorityList),
              const LabeledDropdownButton(
                  label: 'Timeframe', menus: timeFrameList),
              const LabeledTextField(
                label: 'Description',
                hintText:
                    'The purpose of this project is to design a user-friendly and intuitive wireframing to do list application that allows users to create, manage, and track their tasks efficiently',
                maxLines: 8,
                minLines: 8,
              ),

              MaterialButton(
                  color: Colors.indigo,
                  onPressed: () {},
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ))
            ].reversed.toList(),
          ),
        ),
      ),
    ));
  }
}

class LabeledTextField extends StatelessWidget {
  const LabeledTextField(
      {super.key,
      required this.label,
      required this.hintText,
      this.maxLines = 1,
      this.minLines});
  final String label;
  final String hintText;
  final int maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Card(
            elevation: 4.0,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
              ),
              maxLines: maxLines,
              minLines: minLines,
            ),
          )
        ],
      ),
    );
  }
}

class LabeledDropdownButton extends HookWidget {
  const LabeledDropdownButton(
      {super.key, required this.label, required this.menus});
  final String label;
  final List<String> menus;

  @override
  Widget build(BuildContext context) {
    final hint = useState(menus.first);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButton<String>(
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                iconEnabledColor: Colors.indigo,
                underline: const SizedBox(),
                isDense: false,
                isExpanded: true,
                hint: Text(hint.value),
                items: menus
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    hint.value = value;
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
