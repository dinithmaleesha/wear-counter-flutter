import 'package:flutter/material.dart';
import 'package:wear_counter/model/cloth.dart';
import 'dart:io';

class ClothTile extends StatefulWidget {
  final Cloth cloth;
  final VoidCallback onIncrement;
  final VoidCallback onReset;

  const ClothTile({
    Key? key,
    required this.cloth,
    required this.onIncrement,
    required this.onReset,
  }) : super(key: key);

  @override
  _ClothTileState createState() => _ClothTileState();
}

class _ClothTileState extends State<ClothTile> {
  int _currentWears = 0;

  @override
  void initState() {
    _currentWears = widget.cloth.currentWears;
    super.initState();
  }

  void _incrementWearCount() {
    if (_currentWears < widget.cloth.wearCount) {
      setState(() {
        _currentWears++;
      });
      widget.onIncrement();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 64,
          height: 64,
          child: widget.cloth.imagePath.isNotEmpty
              ? Image.file(
                  File(widget.cloth.imagePath),
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.photo, color: Colors.white),
        ),
        title: Text(widget.cloth.name),
        subtitle: Text(
          'Worn: $_currentWears / ${widget.cloth.wearCount}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _incrementWearCount,
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _currentWears = 0;
                });
                widget.onReset();
              },
            ),
          ],
        ),
      ),
    );
  }
}
