import 'package:first_project/design/colors.dart';
import 'package:first_project/design/images.dart';
import 'package:first_project/pages/vehicle/itemDetails.dart';
import 'package:flutter/material.dart';
import '../../design/dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleItem extends StatefulWidget {
  final String title;
  final String owner;
  final String state;
  final String? imageUrl;
  final String description;
  final int index;

  const VehicleItem({
    super.key,
    required this.title,
    required this.owner,
    required this.state,
    required this.description,
    this.imageUrl,
    required this.index
  });

  @override
  _VehicleItemState createState() => _VehicleItemState();
}

class _VehicleItemState extends State<VehicleItem> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height64,
      child: Card(
        color: surfaceColor,
        margin: EdgeInsets.zero,
        elevation: 0.06,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius8),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(radius8),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VehicleDetailsScreen(
                  title: widget.title,
                  owner: widget.owner,
                  description: widget.description,
                  index: widget.index,
                  isFavorite: isFavorite,
                ),
              ),
            );

            if (result != null && result is bool) {
              setState(() {
                isFavorite = result;
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: padding8, right: padding16),
            child: Row(
              children: <Widget>[
                _buildImage(),
                _title(),
                _state(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return Image.network(
        widget.imageUrl!,
        width: 65,
        height: 40,
        fit: BoxFit.contain,
      );
    } else {
      return vehicleMotorcycleImage;
    }
  }

  Widget _title() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: padding6, right: padding6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: secondaryColor,
                fontSize: fontSize14,
                fontWeight: FontWeight.w600,
              ),
            ),
            RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: const TextStyle(fontSize: fontSize14),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Owner: ',
                    style: TextStyle(
                      color: secondaryVariantColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: widget.owner,
                    style: const TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _state() {
    return InkWell(
      onTap: _toggleFavorite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: isFavorite ? Colors.amber : Colors.grey,
          ),
          Text(
            widget.state,
            style: const TextStyle(
              color: secondaryVariantColor,
              fontSize: fontSize12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}




