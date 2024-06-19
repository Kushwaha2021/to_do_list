import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:to_do_list/constants.dart';
import '../main.dart';
import '../services/todo_service.dart';
import '../services/auth_service.dart';
import '../models/todo_model.dart';
import 'add_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _showItem;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showItem=0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'To Do List',
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: mainColor,
        actions: [popupMenu(context)],
      ),
      body: StreamBuilder(
            stream: context.read<TodoService>().fetchTodos(),
            builder: (context, snapshot) {
              List<Todo> data = snapshot.data ?? [];
              if (snapshot.connectionState == ConnectionState.waiting ) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (data.isEmpty || (_showItem==0?(data.
              where((e)=>e.createdAt.difference(DateTime(1999,1,1)).inDays>1)
                  .length):(_showItem==1?data.
              where((e)=>!e.isComplete)
                  .length:data.
              where((e)=>e.isComplete)
                  .length))<1) {
                return const Center(
                    child: Text(
                  'No Data !',
                  style: TextStyle(fontSize: 20),
                ));
              }
              else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: _showItem==0?(data.
              where((e)=>e.createdAt.difference(DateTime(1999,1,1)).inDays>1)
                .length):(_showItem==1?data.
              where((e)=>!e.isComplete)
                  .length:data.
              where((e)=>e.isComplete)
                  .length),

              itemBuilder: (context, index) {
                final todo = _showItem==0?(data.
                where((e)=>e.createdAt.difference(DateTime(1999,1,1)).inDays>1)
                    .toList()[index]):(_showItem==1?data.
                where((e)=>!e.isComplete)
                    .toList()[index]:data.
                where((e)=>e.isComplete)
                    .toList()[index]);

                return Dismissible(
                    key: Key(todo.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      context.read<TodoService>().deleteTodo(
                        todo.id,
                      );
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
                    child:
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(todo.title,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize:18,fontWeight:FontWeight.bold,decoration: todo.isComplete?TextDecoration.lineThrough:null,)),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              todo.description,
                              style: TextStyle(color: Colors.grey,decoration: todo.isComplete?TextDecoration.lineThrough:null),
                              overflow: TextOverflow.ellipsis,
                            ),

                            RichText(
                              text:  TextSpan(
                                text: 'Due date: ',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                   TextSpan(
                                      text: '${convertToDateOnly(todo.dueDate)}',
                                      style:  TextStyle(color: Colors.grey,decoration: todo.isComplete?TextDecoration.lineThrough:null)),

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
                              builder: (context) => AddTodoScreen(todo: todo),
                            ),
                          );
                        },
                      ),
                    ));
              },
            ),
          );
              }
            //},);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget popupMenu(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: mainColor.withOpacity(0.3),
      ),
      child: PopupMenuButton(
        initialValue: _showItem,
        icon: const Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
        itemBuilder: (BuildContext context) => [
           const PopupMenuItem<int>(
            value: 0,
            child:
                Text("All"),

          ),

          const PopupMenuItem<int>(
            value: 1,
            child:
            Text("Pending"),

          ),
           const PopupMenuItem<int>(
            value: 2,
            child:
            Text("Completed"),

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
        onSelected: (index) async {
          if (index == 0) {
            setState(() {
              _showItem=index;
            });
          }
          else if (index == 1) {
            setState(() {
              _showItem=index;
            });
          }
          else if (index == 2) {
            setState(() {
              _showItem=index;
            });
          }
          else {
            Provider.of<AuthService>(context, listen: false).signOut();
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        //color: mainColor,
        elevation: 4.0,
      ),
    );
  }
}
