import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/images/gikilogo.jpg'), // Replace with your logo
      ),
      title: const Text(
        "Haazri-Hub",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/haazrihublogo.png'), // Replace with your logo
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
