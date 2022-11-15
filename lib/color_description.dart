import 'package:flutter/material.dart';
import 'package:testedb2/home.dart';
import 'sql_helper.dart';

class Page4 extends StatefulWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  @override
  Widget build(BuildContext context) {
    String nome = 'azul';
    String hex = '#0000ff';
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
      body: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(300),
                            //border: Border.all(color: Colors.black, width: 3)
                        ),
                      )
                  ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        nome,
                        style: const TextStyle(
                          fontSize: 40.0,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        hex,
                        style: const TextStyle(
                          fontSize: 30.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
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

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  String _titleController = 'azul';
  TextEditingController _descriptionController = TextEditingController();
  String _hexController = '#0000FF';



  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
      _journals.firstWhere((element) => element['id'] == id);
      _titleController = existingJournal['title'];
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
        _titleController, _descriptionController.text, _hexController);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully added a color!'),
    ));
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id, _titleController, _descriptionController.text, _hexController);
    _refreshJournals();
  }


}
