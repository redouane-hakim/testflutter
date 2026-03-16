import 'package:flutter/material.dart';
import 'database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;

  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  TextEditingController controller = TextEditingController();

  List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();
    refreshStudents();
  }

  // afficher étudiants
  void refreshStudents() async {

    final data = await DatabaseHelper.instance.getStudents();

    setState(() {
      students = data;
    });
  }

  // ajouter étudiant
  void addStudent() async {

    if (controller.text.isEmpty) return;

    await DatabaseHelper.instance.insertStudent(controller.text);

    controller.clear();

    refreshStudents();
  }

  // supprimer étudiant
  void deleteStudent(int id) async {

    await DatabaseHelper.instance.deleteStudent(id);

    refreshStudents();
  }

  // modifier étudiant
  void editStudent(int id, String name) {
    TextEditingController editController = TextEditingController(text: name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Modifier étudiant"),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text("Modifier"),
              onPressed: () async {
                // Empêche les noms vides
                if (editController.text.isEmpty) return;

                // Met à jour la base de données
                await DatabaseHelper.instance.updateStudent(
                  id,
                  editController.text,
                );

                // Ferme la boîte de dialogue
                Navigator.pop(context);

                // Recharge la liste des étudiants pour voir le changement
                refreshStudents();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(

        appBar: AppBar(
          title: Text("Gestion des étudiants"),
        ),

        body: Padding(
          padding: EdgeInsets.all(20),

          child: Column(
            children: [

              Row(
                children: [

                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: "Nom étudiant",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(width: 10),

                  ElevatedButton(
                    onPressed: addStudent,
                    child: Text("Ajouter"),
                  )

                ],
              ),

              SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {

                    final student = students[index];

                    return ListTile(

                      leading: Text(student['id'].toString()),

                      title: Text(student['name']),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              editStudent(
                                  student['id'], student['name']);
                            },
                          ),

                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteStudent(student['id']);
                            },
                          ),

                        ],
                      ),
                    );
                  },
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}