// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wear_counter/model/cloth.dart';
import 'package:wear_counter/widgets/cloth_tile.dart';
import 'package:wear_counter/db/db_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DBHelper _dbHelper = DBHelper();
  List<Cloth> clothList = [];

  @override
  void initState() {
    super.initState();
    _fetchClothItems();
  }

  // get all cloths
  void _fetchClothItems() async {
    List<Cloth> cloths = await _dbHelper.getClothingItems();
    print('Number of cloth items fetched: ${cloths.length}');
    setState(() {
      clothList = cloths;
    });
  }

  // show add new cloth dialog
  void _showAddClothDialog() {
    String newClothName = '';
    int newWearCount = 1;
    File? _image;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Cloth'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Select Image'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Pick from gallery'),
                                    onTap: () async {
                                      final pickedFile = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);
                                      if (pickedFile != null) {
                                        setState(() {
                                          _image = File(pickedFile.path);
                                        });
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text('Take a picture'),
                                    onTap: () async {
                                      final pickedFile = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.camera);
                                      if (pickedFile != null) {
                                        setState(() {
                                          _image = File(pickedFile.path);
                                        });
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.grey),
                        ),
                        child: _image != null
                            ? Image.file(_image!, fit: BoxFit.cover)
                            : const Center(
                                child: Icon(Icons.camera_alt, size: 50),
                              ),
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Cloth Name',
                      ),
                      onChanged: (val) {
                        newClothName = val;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Wear Count',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        newWearCount = int.tryParse(val) ?? 1;
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () async {
                    if (_image != null && newClothName.isNotEmpty) {
                      // Perform insertion logic with image
                      int insertedId = await _dbHelper.insertClothingItem(Cloth(
                        name: newClothName,
                        imagePath: _image!.path,
                        wearCount: newWearCount,
                        currentWears: 0,
                      ));
                      if (insertedId != -1) {
                        _fetchClothItems();
                        print('Cloth inserted with id: $insertedId');
                      } else {
                        print('Failed to insert cloth into database');
                      }
                      Navigator.of(context).pop();
                    } else {
                      print('Please select an image and enter cloth name.');
                      Fluttertoast.showToast(
                        msg: 'Please select an image and enter cloth name.',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wear Counter',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(63, 81, 181, 1),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: _showAddClothDialog,
              tooltip: 'Add Cloth',
            ),
          ),
        ],
      ),
      body: clothList.isEmpty
          ? const Center(
              child: Text(
                'Add cloth',
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: clothList.length,
              itemBuilder: (context, index) {
                final cloth = clothList[index];
                return ClothTile(
                  cloth: cloth,
                  onIncrement: () {
                    if (cloth.currentWears < cloth.wearCount) {
                      setState(() {
                        cloth.currentWears++;
                      });
                    }
                  },
                  onReset: () {
                    setState(() {
                      cloth.currentWears = 0;
                    });
                  },
                );
              },
            ),
    );
  }
}
