import 'package:first_project/design/colors.dart';
import 'package:first_project/design/dimensions.dart';
import 'package:first_project/pages/vehicle/vehicle_list.dart';
import 'package:flutter/material.dart';

class VehiclePage extends StatelessWidget {
  const VehiclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: surfaceColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: const Text(
            'Dispatcher by san',
            style: TextStyle(
              color: primaryColor,
              fontSize: fontSize16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: backgroundColor,
            child: const VehicleList(),
          ),
        ),
      ],
    );
  }
}
