// add_task.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const AddTask({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController _textEditingController = TextEditingController();
  DateTime time = DateTime.now();
  bool switchValue = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          title: const Row(
            children: [
              SizedBox(width: 60),
              Text(
                'Task',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          leadingWidth: 100,
          leading: TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Container(
              width: 15,
              child: Icon(Icons.arrow_back_ios_new_rounded),
            ),
            label: Container(
              width: 47,
              child: const Text(
                'Close',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'Add a task',
                  style: TextStyle(
                    fontFamily: 'SF-Pro',
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 0),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(height: 0),
                        const Text(
                          'Name',
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.38,
                          ),
                        ),
                        const SizedBox(height: 0),
                        Container(
                          margin: const EdgeInsets.all(30),
                          height: 50,
                          width: 225,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: TextFormField(
                            controller: _textEditingController,
                            decoration: const InputDecoration(
                              labelText: 'Task Name',
                              // border: OutlineInputBorder(
                              //   borderSide: BorderSide(
                              //     color: Colors.black,
                              //     style: BorderStyle.solid,
                              //   ),
                              // ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 0),
                    Row(
                      children: [
                        const Text(
                          'Hour',
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.38,
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Container(
                          height: 40,
                          width: 170,
                          child: CupertinoDatePicker(
                            initialDateTime: time,
                            mode: CupertinoDatePickerMode.time,
                            use24hFormat: false,
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() => time = newTime);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const Text(
                          'Today',
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.38,
                          ),
                        ),
                        const SizedBox(
                          width: 210,
                        ),
                        Container(
                          height: 40,
                          width: 60,
                          child: CupertinoSwitch(
                            activeColor: Colors.green,
                            thumbColor: Colors.white,
                            trackColor: Colors.black12,
                            value: switchValue,
                            onChanged: (value) =>
                                setState(() => switchValue = value),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Map<String, dynamic> newTask = {
                      'name': _textEditingController.text,
                      'time': time,
                      'dueToday': switchValue,
                    };

                    widget.onAdd(newTask);

                    Navigator.of(context).pop({});
                  },
                  child: Container(
                    height: 46,
                    width: 316,
                    child: Center(
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'If you disable today, the task will be considered as \ntomorrow',
                  style: TextStyle(fontFamily: 'SF-Pro', color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TodoItem {
  String task;
  bool isCompleted;
  DateTime time;
  bool dueToday;

  TodoItem({
    required this.task,
    required this.isCompleted,
    required this.time,
    required this.dueToday,
  });
}