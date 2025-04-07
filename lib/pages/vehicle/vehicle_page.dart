import 'package:first_project/design/colors.dart';
import 'package:first_project/design/dimensions.dart';
import 'package:flutter/material.dart';

class VehiclePage extends StatelessWidget {
  const VehiclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dispatcher by san',
          style: TextStyle(
            color: primaryColor,
            fontSize: fontSize16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: surfaceColor,
        elevation: 0,
      ),
      body: Container(color: backgroundColor, child: const Text('body')),
    );
  }
}
