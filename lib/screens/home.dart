// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wear_counter/model/cloth.dart';
import 'package:wear_counter/shared/constants.dart';
import 'package:wear_counter/widgets/cloth_tile.dart';
import 'package:wear_counter/db/db_helper.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DBHelper _dbHelper = DBHelper();
  List<Cloth> clothList = [];
  bool isLoading = true;

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
      isLoading = false;
    });
  }

  // show add new cloth dialog
  void _showAddClothDialog() {
    String newClothName = '';
    int newWearCount = 1;
    File? image;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Add New Cloth',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: tileSecondColor,
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
                              title: const Text(
                                'Select Image',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: tileSecondColor,
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text(
                                      'Pick from gallery',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () async {
                                      final pickedFile = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);
                                      if (pickedFile != null) {
                                        setState(() {
                                          image = File(pickedFile.path);
                                        });
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text(
                                      'Take a picture',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () async {
                                      final pickedFile = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.camera);
                                      if (pickedFile != null) {
                                        setState(() {
                                          image = File(pickedFile.path);
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
                          color: tileColor,
                          border: Border.all(color: Colors.white),
                        ),
                        child: image != null
                            ? Image.file(image!, fit: BoxFit.cover)
                            : const Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                  color: Colors.white,
                                ),
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
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter a cloth name';
                        } else if (val.length >= 30) {
                          return 'Please enter a shorter cloth name';
                        }
                        return null;
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
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter a wear count';
                        } else {
                          final parsedValue = int.tryParse(val);
                          if (parsedValue == null) {
                            return 'Please enter a valid number';
                          } else if (parsedValue > 10) {
                            return 'Please wash your clothes';
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (image != null && newClothName.isNotEmpty) {
                      // Perform insertion logic with image
                      int insertedId = await _dbHelper.insertClothingItem(Cloth(
                        name: newClothName,
                        imagePath: image!.path,
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
                      showCustomToast(
                          'Please select an image and enter cloth name.');
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

  void _showUpdateDeleteOptions(BuildContext context, Cloth cloth) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: tileSecondColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  _openUpdateClothDialog(cloth);
                },
              ),
              ListTile(
                title: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  _deleteCloth(context, cloth);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteCloth(BuildContext context, Cloth cloth) async {
    int rowDeleted = await _dbHelper.deleteClothingItem(cloth.id!);
    if (rowDeleted != -1) {
      showCustomToast('Cloth Deleted!');
      _fetchClothItems();
    }
  }

  void _openUpdateClothDialog(Cloth cloth) {
    String newClothName = cloth.name;
    int newWearCount = cloth.wearCount;
    File? image = File(cloth.imagePath);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Update Cloth',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: tileSecondColor,
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
                              title: const Text(
                                'Select Image',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: tileSecondColor,
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text(
                                      'Pick from gallery',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () async {
                                      final pickedFile = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);
                                      if (pickedFile != null) {
                                        setState(() {
                                          image = File(pickedFile.path);
                                        });
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text(
                                      'Take a picture',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () async {
                                      final pickedFile = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.camera);
                                      if (pickedFile != null) {
                                        setState(() {
                                          image = File(pickedFile.path);
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
                        child: image != null
                            ? Image.file(image!, fit: BoxFit.cover)
                            : const Center(
                                child: Icon(Icons.camera_alt, size: 50),
                              ),
                      ),
                    ),
                    TextFormField(
                      initialValue: newClothName,
                      decoration: const InputDecoration(
                        hintText: 'Cloth Name',
                      ),
                      onChanged: (val) {
                        newClothName = val;
                      },
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter a cloth name';
                        } else if (val.length >= 10) {
                          return 'Please enter a shorter cloth name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: newWearCount.toString(),
                      decoration: const InputDecoration(
                        hintText: 'Wear Count',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        newWearCount = int.tryParse(val) ?? 1;
                      },
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter a wear count';
                        } else {
                          final parsedValue = int.tryParse(val);
                          if (parsedValue == null) {
                            return 'Please enter a valid number';
                          } else if (parsedValue > 10) {
                            return 'Please wash your clothes';
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (newClothName.isNotEmpty) {
                      await _updateCloth(cloth.id!, newClothName,
                          image?.path ?? cloth.imagePath, newWearCount);
                      Navigator.of(context).pop();
                    } else {
                      showCustomToast('Please enter cloth name.');
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

  Future<void> _updateCloth(
      int id, String newName, String imagePath, int newWearCount) async {
    int updateId = await _dbHelper.updateClothingItem(Cloth(
      id: id,
      name: newName,
      imagePath: imagePath,
      wearCount: newWearCount,
      currentWears: 0,
    ));
    if (updateId != -1) {
      showCustomToast('Cloth details updated.');
      _fetchClothItems();
      Navigator.pop(context);
    }
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
        backgroundColor: mainColor,
        elevation: 0.0,
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
      backgroundColor: mainColor,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : clothList.isEmpty
              ? const Center(
                  child: Text(
                    'Add cloth',
                    style: TextStyle(fontSize: 20, color: Colors.white10),
                  ),
                )
              : ListView.builder(
                  itemCount: clothList.length,
                  itemBuilder: (context, index) {
                    final cloth = clothList[index];
                    return GestureDetector(
                      onLongPress: () {
                        _showUpdateDeleteOptions(context, cloth);
                      },
                      child: ClothTile(
                        cloth: cloth,
                        onIncrement: () async {
                          if (cloth.currentWears < cloth.wearCount) {
                            setState(() {
                              cloth.currentWears++;
                            });
                            await _dbHelper.updateClothCurrentWears(
                                cloth.id!, cloth.currentWears);
                          }
                        },
                        onDecrement: () async {
                          if (cloth.currentWears != 0) {
                            setState(() {
                              cloth.currentWears--;
                            });
                            await _dbHelper.updateClothCurrentWears(
                                cloth.id!, cloth.currentWears);
                          }
                        },
                        onReset: () async {
                          setState(() {
                            cloth.currentWears = 0;
                          });
                          await _dbHelper.updateClothCurrentWears(cloth.id!, 0);
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
