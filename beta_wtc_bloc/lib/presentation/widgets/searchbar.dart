import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final Function onChanged;
  const SearchBarWidget({Key? key, required this.onChanged}) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF222222),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Align(
          alignment: Alignment.center,
          child: TextFormField(
            onChanged: (String? value) {
              widget.onChanged(value.toString());
            },
            style: const TextStyle(
              color: Color(0xFF847968),
            ),
            decoration: const InputDecoration(
              labelText: "Search",
              labelStyle: TextStyle(
                color: Color(0xFF847968),
              ),
              icon: Icon(
                Icons.search,
                color: Color(0xFF847968),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
