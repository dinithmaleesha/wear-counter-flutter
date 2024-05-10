import 'package:flutter/material.dart';
import 'package:wear_counter/model/cloth.dart';
import 'package:wear_counter/widgets/cloth_tile.dart';
import 'package:wear_counter/db/db_helper.dart';

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

  void _fetchClothItems() async {
    List<Cloth> cloths = await _dbHelper.getClothingItems();
    setState(() {
      clothList = cloths;
    });
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
              onPressed: () {
                // TODO: implement this
              },
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
