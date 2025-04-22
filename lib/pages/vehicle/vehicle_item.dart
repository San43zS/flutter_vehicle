import 'package:first_project/design/colors.dart';
import 'package:first_project/design/images.dart';
import 'package:first_project/pages/vehicle/itemDetails.dart';
import 'package:flutter/material.dart';
import '../../design/dimensions.dart';

class VehicleItem extends StatelessWidget {
  final String title;
  final String driver;
  final String state;
  final String? imageUrl;
  final int index;

  const VehicleItem({
    super.key,
    required this.title,
    required this.driver,
    required this.state,
    this.imageUrl,
    required this.index
  });

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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VehicleDetailsScreen(
                  title: title,
                  driver: driver,
                  state: state,
                  index: index,
                ),
              ),
            );
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
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
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
              title,
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
                    text: 'Driver: ',
                    style: TextStyle(
                      color: secondaryVariantColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: driver,
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
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          statePickupImage,
          Text(
            state,
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


