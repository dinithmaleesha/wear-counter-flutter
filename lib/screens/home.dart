import 'package:flutter/material.dart';
import 'package:wear_counter/model/cloth.dart';
import 'package:wear_counter/widgets/cloth_tile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Cloth> clothList = [
    Cloth(
      id: 1,
      name: 'T-Shirt',
      imagePath: 'assets/tshirt.png',
      wearCount: 3,
      currentWears: 1,
    ),
    Cloth(
      id: 2,
      name: 'Jeans',
      imagePath: 'assets/jeans.png',
      wearCount: 5,
      currentWears: 2,
    ),
    Cloth(
      id: 3,
      name: 'Dress Shirt',
      imagePath: 'assets/shirt.png',
      wearCount: 4,
      currentWears: 0,
    ),
  ];

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
      body: ListView.builder(
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
