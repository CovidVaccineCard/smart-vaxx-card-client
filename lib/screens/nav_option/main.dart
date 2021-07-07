import 'package:smart_vaxx_card_client/constants.dart';
import 'package:flutter/material.dart';

class NavigationOption extends StatelessWidget {
  const NavigationOption(
      {required this.title, required this.selected, required this.onSelected});

  final String title;
  final bool selected;
  final Function() onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onSelected();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: selected ? kPrimaryColor : Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              selected
                  ? Column(
                      children: <Widget>[
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
