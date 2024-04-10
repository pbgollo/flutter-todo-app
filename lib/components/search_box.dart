import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {

  const SearchBox({super.key,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.black,
            size: 20,
          ),
          prefixIconConstraints: const BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: "Pesquisar",
          hintStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 15
          ),
        ),
      ),
    ); 
  }
}