import 'package:flutter/material.dart';

class NewRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final double sizeFont;
  final VoidCallback onTap;

  NewRow({
    Key key,
    this.icon,
    this.sizeFont,
    this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 20),
          Text(text, style: TextStyle(color: Colors.white, fontSize: sizeFont)),
        ],
      ),
    );
  }
}
