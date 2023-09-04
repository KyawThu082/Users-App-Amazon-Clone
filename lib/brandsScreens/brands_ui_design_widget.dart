import 'package:flutter/material.dart';

import '../itemsScreens/items_screen.dart';
import '../models/brands.dart';

// ignore: must_be_immutable
class BrandsUiDesignWidget extends StatefulWidget {
  Brands? model;
  BuildContext? context;

  BrandsUiDesignWidget({super.key, this.model, this.context});

  @override
  State<BrandsUiDesignWidget> createState() => _BrandsUiDesignWidgetState();
}

class _BrandsUiDesignWidgetState extends State<BrandsUiDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ItemsScreen(
                      model: widget.model,
                    )));
      },
      child: Card(
        color: Colors.black,
        elevation: 10,
        shadowColor: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SizedBox(
            height: 270,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    widget.model!.thumbnailUrl.toString(),
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  widget.model!.brandTitle.toString(),
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
