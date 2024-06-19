import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../constants.dart';
import '../services/todo_service.dart';
import '../models/todo_model.dart';
import 'package:intl/intl.dart';

class AddTodoScreen extends StatefulWidget {
  final Todo? todo;

  const AddTodoScreen({super.key, this.todo});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  bool _isComplete = false;
  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _descriptionController.text = widget.todo!.description;
      _dueDate = widget.todo!.dueDate;
      _isComplete = widget.todo!.isComplete;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.todo == null ? 'Add To-Do' : 'Edit To-Do',style: const TextStyle(fontSize: 24, color:Colors.white,fontWeight: FontWeight.bold),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          splashColor: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
            // Handle search button press
          },
        ),
        backgroundColor:  mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.h,),
            TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                maxLines: null,
          
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: mainColor),
                  ),
                ),
          
                autovalidateMode:
                AutovalidateMode.onUserInteraction,
              ),
              SizedBox(height: 5.h,),
              TextField(
                controller: _descriptionController,
                maxLines: null,
                decoration:  InputDecoration(
                labelText: 'Description',
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: mainColor),
                ),
              ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Due Date: '),
                  Text(_dueDate == null
                      ? 'No Date Chosen'
                      : convertToDateOnly(_dueDate!),
                  style: TextStyle(color: _dueDate == null?Colors.red:mainColor),),
                  const Spacer(),
                  TextButton(
                    onPressed: _pickDueDate,
                    child: const Icon(Icons.calendar_month),
                  ),
                ],
              ),
          IgnorePointer(
              ignoring: widget.todo == null,
                child: SwitchListTile(
                  title: const Text('Complete'),
                  value: _isComplete,
                  onChanged: (value) {
                    setState(() {
                      _isComplete = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minimumSize: Size(30.w, 6.h), //////// HERE
                ),
                onPressed: _saveTodo,
                child: Text(widget.todo == null ? 'Add' : 'Save',style: const TextStyle(fontSize: 20),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDueDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _dueDate = selectedDate;
      });
    }
  }

  void _saveTodo() {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty || _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all the fields')));
      return;
    }

    final todo = Todo(
      id: widget.todo?.id ?? '',
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _dueDate!,
      isComplete: _isComplete,
      createdAt: widget.todo == null?DateTime.now():widget.todo!.createdAt,
    );

    if (widget.todo == null) {
      Provider.of<TodoService>(context, listen: false).addTodo(todo);
    } else {
      Provider.of<TodoService>(context, listen: false).updateTodo( todo);
    }

    Navigator.pop(context);
  }
}
