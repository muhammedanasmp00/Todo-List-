import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:self_project/TaskPage.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoItem> todos = [];
  bool showTodayTasks = true;
  bool showTomorrowTasks = true;

  @override
  Widget build(BuildContext context) {
    List<TodoItem> todayTasks = [];
    List<TodoItem> tomorrowTasks = [];

    for (var task in todos) {
      if (task.dueToday) {
        todayTasks.add(task);
      } else {
        tomorrowTasks.add(task);
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: const [
            CircleAvatar(
              radius: 20,
            ),
            SizedBox(width: 10),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTask(
                  onAdd: (newTask) {
                    _addTodo(newTask);
                  },
                ),
              ),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildToggleSection('Today', showTodayTasks, () {
                setState(() {
                  showTodayTasks = !showTodayTasks;
                });
              }, false),
            ),
            if (showTodayTasks)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildTaskListItem(todayTasks[index]),
                  childCount: todayTasks.length,
                ),
              ),
            SliverToBoxAdapter(
              child: _buildToggleSection('Tomorrow', showTomorrowTasks, () {
                setState(() {
                  showTomorrowTasks = !showTomorrowTasks;
                });
              }, false),
            ),
            if (showTomorrowTasks)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildTaskListItem(tomorrowTasks[index]),
                  childCount: tomorrowTasks.length,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskListItem(TodoItem task) {
    return ListTile(
      key: Key('todo_${task.task}'),
      onLongPress: () {
        _showDeleteDialog(context, task);
      },
      leading: !showBlackDot(task)
          ? Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              activeColor: Colors.black,
              value: task.isCompleted,
              onChanged: (value) {
                _toggleTodoCompleted(task, value!);
              },
            )
          : Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
              ),
            ),
      title: Text(
        task.task,
        style: TextStyle(
          fontFamily: 'SF-Pro',
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          color: task.isCompleted ? Colors.grey : null,
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
        ),
      ),
      subtitle: Text(
        _formatTime(task.time),
        style: const TextStyle(
          fontFamily: 'SF-Pro',
          color: Colors.grey,
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
        ),
      ),
      trailing: task.dueToday
          ? IconButton(
              icon: Icon(
                Icons.edit_note,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () {
                _renameTask(context, task);
              },
            )
          : null,
    );
  }

  void _renameTask(BuildContext context, TodoItem task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _textEditingController =
            TextEditingController(text: task.task);

        return AlertDialog(
          title: const Text('Rename Task'),
          content: TextFormField(
            controller: _textEditingController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _renameTodo(task, _textEditingController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Rename'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        );
      },
    );
  }

  void _renameTodo(TodoItem task, String newName) {
    setState(() {
      task.task = newName;
    });
  }

  bool showBlackDot(TodoItem task) {
    return !task.isCompleted && !task.dueToday;
  }

  Widget _buildToggleSection(
      String title, bool showTasks, VoidCallback onPressed, bool isTomorrow) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'SF-Pro',
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          CupertinoButton(
            onPressed: onPressed,
            child: Text(
              showTasks ? 'Hide completely' : 'Show completely',
              style: const TextStyle(
                fontFamily: 'SF-Pro',
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addTodo(Map<String, dynamic> newTask) {
    if (newTask['name'].isNotEmpty) {
      setState(() {
        todos.add(TodoItem(
          task: newTask['name'],
          isCompleted: false,
          time: newTask['time'],
          dueToday: newTask['dueToday'],
        ));
      });
    }
  }

  void _toggleTodoCompleted(TodoItem task, bool value) {
    setState(() {
      task.isCompleted = value;
    });
  }

  void _showDeleteDialog(BuildContext context, TodoItem task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _deleteTodo(task);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        );
      },
    );
  }

  void _deleteTodo(TodoItem task) {
    setState(() {
      todos.remove(task);
    });
  }

  String _formatTime(DateTime time) {
    int hour = time.hour;
    String period = (hour < 12) ? 'AM' : 'PM';

    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    final formattedTime = "$hour:${time.minute} $period";
    return formattedTime;
  }
}
