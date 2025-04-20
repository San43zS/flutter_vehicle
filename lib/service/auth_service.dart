import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> saveUserToFirestore(User user) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

  await userDoc.set({
    'name': user.email?.split('@').first ?? '-',
    'email': user.email ?? '-',
    'dateOfBirth': '-',
    'phoneNumber': '-',
    'address': '-',
    'bio': '-',
    'occupation': '-',
    'website': '-',
    'socialMedia': '-',
    'additionalInfo': '-',
    'createdAt': FieldValue.serverTimestamp(),
  });
}