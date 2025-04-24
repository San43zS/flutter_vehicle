import 'package:first_project/design/dimensions.dart';
import 'package:first_project/design/images.dart';
import 'package:first_project/design/widget/accent_button.dart';
import 'package:first_project/pages/vehicle/vehicle_item.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleList extends StatelessWidget {
  const VehicleList({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _listFromFirestore(),
      ],
    );
  }

  Widget _listFromFirestore() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('cars').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Ошибка загрузки данных'));
        }

        final cars = snapshot.data?.docs ?? [];

        if (cars.isEmpty) {
          return const Center(child: Text('Список пуст'));
        }

        return ListView.separated(
          padding: const EdgeInsets.only(
            left: padding16,
            top: padding16,
            right: padding16,
          ),
          itemCount: cars.length,
          separatorBuilder: (context, index) => const SizedBox(height: height8),
          itemBuilder: (context, index) {
            final car = cars[index].data() as Map<String, dynamic>;

            return VehicleItem(
              title: car['title'] ?? 'Без названия',
              owner: car['owner'] ?? 'Неизвестный',
              description: car['description'],
              state:'state',
              imageUrl: (car['images'] != null &&
                  car['images'] is List &&
                  car['images'].isNotEmpty)
                  ? car['images'][0] as String
                  : null,
              index: index,
            );
          },
        );
      },
    );
  }

}
