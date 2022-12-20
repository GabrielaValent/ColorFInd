import 'package:flutter/material.dart';
import 'package:testedb2/home.dart';
import 'sql_helper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';



class Page4 extends StatefulWidget {
  Page4({Key? key}) : super(key: key);

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {

  String color="";
  String name_color="";

  late DatabaseReference imagensRef;

  late StreamSubscription<DatabaseEvent> colorSubscription;
  late StreamSubscription<DatabaseEvent> name_colorSubscription;

  //bool _ISLoading = true;

  @override
  void initState() {
    super.initState();
    init();
    _refreshJournals(); // Loading the diary when the app starts
  }

  init() async {
    imagensRef = FirebaseDatabase.instance.ref('Imagens');

    try {
      DatabaseEvent colorget = await imagensRef.once();
      DatabaseEvent name_colorget = await imagensRef.once();

      setState(() {
        color = colorget.snapshot.child("color") as String ;
        name_color = name_colorget.snapshot.child("name_color") as String;
      });
    } catch (err) {
      print(err.toString());
    }

    colorSubscription = imagensRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        color = (event.snapshot.child("color").value) as String;
      });
    });

    name_colorSubscription = imagensRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        name_color = (event.snapshot.child("name_color").value) as String;
      });
    });

  }

  @override
  void dispose() {
    colorSubscription.cancel();
    name_colorSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ColorFind",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false,
      ),
      body: /*ISLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          :*/
      Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 50.0,
                        ),
                        AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(int.parse(color.replaceAll('#', '0xff'))),
                                borderRadius: BorderRadius.circular(300),
                                //border: Border.all(color: Colors.black, width: 3)
                              ),
                            )
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          color,
                          style: const TextStyle(
                            fontSize: 40.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          name_color,
                          style: const TextStyle(
                            fontSize: 30.0,
                            color: Colors.black,
                          ),
                        ),

                      ],
                    ),
                  )
              )
            ),
          ),
        ],
      ),
      bottomNavigationBar: buildMyNavBar2(context),
    );


  }

  Container buildMyNavBar2(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.purple,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white, size: 35),
            enableFeedback: false,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.star_border_outlined, color: Colors.white, size: 35),
            enableFeedback: false,
            onPressed: () {
              _showForm(null);
            },
          ),
        ],
      ),
    );
  }



  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }



  TextEditingController _descriptionController = TextEditingController();



  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
      _journals.firstWhere((element) => element['id'] == id);
      name_color = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
      _descriptionController = existingJournal['hex'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            // this will prevent the soft keyboard from covering the text fields
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(hintText: 'Descrição(Opcional)'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  // Save new journal
                  if (id == null) {
                    await _addItem();
                  }

                  if (id != null) {
                    await _updateItem(id);
                  }

                  // Clear the text fields
                  //_titleController = '';
                  _descriptionController.text = '';
                  //_hexController = '';

                  // Close the bottom sheet
                  Navigator.of(context).pop();
                },
                child: Text(id == null ? 'Create New' : 'Update'),
              )
            ],
          ),
        ));



  }

// Insert a new journal to the database
  Future<void> _addItem() async {
    await SQLHelper.createItem(
        name_color, _descriptionController.text, color);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully added a color!'),
    ));
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id, name_color, _descriptionController.text, color);
    _refreshJournals();
  }


}