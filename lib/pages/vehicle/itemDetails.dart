import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final String title;
  final String owner;
  final String description;
  final int index;
  final bool isFavorite;

  const VehicleDetailsScreen({
    super.key,
    required this.title,
    required this.owner,
    required this.description,
    required this.index,
    required this.isFavorite
  });

  @override
  _VehicleDetailsScreenState createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0;
  String? _carUid;
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
    isFavorite = widget.isFavorite;
    _getCarUid();
  }

  Future<void> _getCarUid() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('cars')
        .get();

    if (snapshot.docs.isNotEmpty && widget.index < snapshot.docs.length) {
      final doc = snapshot.docs[widget.index];
      setState(() {
        _carUid = doc.id;
      });
    }
  }

  Future<void> _checkIfFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final favDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(widget.index.toString())
        .get();

    if (favDoc.exists) {
      setState(() {
        isFavorite = true;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(widget.index.toString());

    if (isFavorite) {
      await favRef.delete();
    } else {
      await favRef.set({
        'title': widget.title,
        'owner': widget.owner,
        'description': widget.description,
        'addedAt': Timestamp.now(),
        'index': widget.index
      });
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<List<String>> _getImages() async {
    if (_carUid == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('cars')
        .doc(_carUid)
        .get();

    if (snapshot.exists) {
      final List<dynamic> imageList = snapshot['images'] ?? [];
      return List<String>.from(imageList);
    }

    return [];
  }

  Future<List<Map<String, dynamic>>> _getReviews() async {
    if (_carUid == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .doc(_carUid)
        .collection('user_reviews')
        .get();

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<void> _submitReview() async {
    if (_reviewController.text.isEmpty || _rating == 0 || _carUid == null) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('reviews')
        .doc(_carUid)
        .collection('user_reviews')
        .doc(user.uid)
        .set({
      'rating': _rating,
      'review': _reviewController.text,
      'userId': user.uid,
      'timestamp': Timestamp.now(),
    });

    setState(() {
      _reviewController.clear();
      _rating = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFFFF8E1F);

    return
        WillPopScope(
          onWillPop: () async {
        Navigator.pop(context, isFavorite);
        return isFavorite;
      },
      child:Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Car Details'),
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
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            images[i],
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    ),
                  )
                else
                  const SizedBox(height: 200),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Owner: ${widget.owner}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 6),
                      Text('Description: ${widget.description}',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        onPressed: _toggleFavorite,
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                        ),
                        label: Text(
                          isFavorite ? 'Удалить из избранного' : 'Добавить в избранное',
                          style: const TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Leave a Review:',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: List.generate(5, (index) {
                                  return IconButton(
                                    icon: Icon(
                                      _rating > index
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: primaryColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _rating = index + 1.0;
                                      });
                                    },
                                  );
                                }),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _reviewController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter your review...',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 4,
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: _submitReview,
                                  child: const Text(
                                    'Submit Review',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Отзывы
                      Text(
                        'User Reviews:',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _getReviews(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final reviews = snapshot.data ?? [];

                          return Column(
                            children: reviews.map((review) {
                              return Card(
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Row(
                                    children: List.generate(
                                      5,
                                          (i) => Icon(
                                        i < (review['rating'] ?? 0)
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(review['review'] ?? ''),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
    );
  }
}
