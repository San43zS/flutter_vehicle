import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleDetailsScreen extends StatelessWidget {
  final String title;
  final String driver;
  final String state;
  final int index;

  const VehicleDetailsScreen({
    super.key,
    required this.title,
    required this.driver,
    required this.state,
    required this.index,
  });

  Future<List<String>> _getImages() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('cars')
        .get();

    if (snapshot.docs.isNotEmpty && index < snapshot.docs.length) {
      final doc = snapshot.docs[index];
      final List<dynamic> imageList = doc['images'];
      return List<String>.from(imageList);
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Details'),
      ),
      body: FutureBuilder<List<String>>(
        future: _getImages(),
        builder: (context, snapshot) {
          final images = snapshot.data ?? [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (snapshot.connectionState == ConnectionState.waiting)
                  const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (images.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      itemCount: images.length,
                      itemBuilder: (context, i) {
                        return Image.network(
                          images[i],
                          width: double.infinity,
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  )
                else
                  const SizedBox(height: 200),

                // Vehicle Info
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Driver: $driver',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'State: $state',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
