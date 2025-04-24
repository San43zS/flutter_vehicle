import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/pages/vehicle/vehicle_item.dart';
import 'package:flutter/material.dart';
import '../../design/colors.dart';
import '../../design/dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .collection('favorites')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Text('Error loading favorites');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) return const Center(child: Text('No favorites yet'));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: data['imageUrl'] != null
                    ? Image.network(data['imageUrl'], width: 60)
                    : const Icon(Icons.directions_car),
                title: Text(data['title']),
                subtitle: Text('Owner: ${data['owner']}'),
              );
            },
          );
        },
      ),
    );
  }
}