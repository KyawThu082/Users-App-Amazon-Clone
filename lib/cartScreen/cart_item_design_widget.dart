import 'package:flutter/material.dart';
import 'package:users_app/models/items.dart';

// ignore: must_be_immutable
class CartItemDesignWidget extends StatefulWidget {
  Items? model;
  int? quantityNumber;

  CartItemDesignWidget({super.key, this.model, this.quantityNumber});

  @override
  State<CartItemDesignWidget> createState() => _CartItemDesignWidgetState();
}

class _CartItemDesignWidgetState extends State<CartItemDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shadowColor: Colors.white54,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              //Image
              Image.network(
                widget.model!.thumbnailUrl.toString(),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //title
                    Text(
                      widget.model!.itemTitle.toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),

                    //Price: 12 MMK
                    Row(
                      children: [
                        const Text(
                          "Price: ",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          widget.model!.price.toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          " MMK",
                          style: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),
                    //Quantity: x 4
                    Row(
                      children: [
                        const Text(
                          "Quantity: ",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          widget.quantityNumber.toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
