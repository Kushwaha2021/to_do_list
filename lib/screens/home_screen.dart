import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:to_do_list/constants.dart';
import '../services/todo_service.dart';
import '../services/auth_service.dart';
import '../models/todo_model.dart';
import 'add_todo_screen.dart';
import '../services/connectivity_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _showItem = 0;
  late Stream<ConnectivityResult> _connectivityStream;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _showItem = 0;
    _connectivityStream = ConnectivityService().connectivityStream;
    _connectivityStream.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'To Do List',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: mainColor,
        actions: [popupMenu(context)],
      ),
      body: _isConnected
          ? StreamBuilder<List<Todo>>(
        stream: context.read<TodoService>().fetchTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<Todo> todos = snapshot.data ?? [];
          List<Todo> filteredTodos = _filterTodos(todos);

          if (filteredTodos.isEmpty) {
            return const Center(
              child: Text(
                'No Data!',
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: filteredTodos.length,
              itemBuilder: (context, index) {
                final todo = filteredTodos[index];

                return Dismissible(
                  key: Key(todo.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    context.read<TodoService>().deleteTodo(todo.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${todo.title} deleted'),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        todo.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: todo.isComplete
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todo.description,
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: todo.isComplete
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Due date: ',
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                  '${convertToDateOnly(todo.dueDate)}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    decoration: todo.isComplete
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      trailing: Checkbox(
                        value: todo.isComplete,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onChanged: (value) {
                          context.read<TodoService>().updateTodo(
                            todo.copyWith(isComplete: value!),
                          );
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddTodoScreen(todo: todo),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      )
          : const Center(
        child: Text(
          'No internet connection!',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isConnected
            ? () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTodoScreen()),
          );
        }
            : null,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget popupMenu(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: mainColor.withOpacity(0.3),
      ),
      child: PopupMenuButton<int>(
        initialValue: _showItem,
        icon: const Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem<int>(
            value: 0,
            child: Text("All"),
          ),
          const PopupMenuItem<int>(
            value: 1,
            child: Text("Pending"),
          ),
          const PopupMenuItem<int>(
            value: 2,
            child: Text("Completed"),
          ),
          PopupMenuItem<int>(
            value: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Sign Out"),
                SizedBox(
                  width: 0.3.w,
                ),
                const Icon(
                  Icons.power_settings_new_sharp,
                ),
              ],
            ),
          ),
        ],
        onSelected: (index) {
          if (index == 3) {
            Provider.of<AuthService>(context, listen: false).signOut();
          } else {
            setState(() {
              _showItem = index;
            });
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        elevation: 4.0,
      ),
    );
  }

  List<Todo> _filterTodos(List<Todo> todos) {
    switch (_showItem) {
      case 1:
        return todos.where((todo) => !todo.isComplete).toList();
      case 2:
        return todos.where((todo) => todo.isComplete).toList();
      default:
        return todos;
    }
  }
}
