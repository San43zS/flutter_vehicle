import 'package:first_project/design/colors.dart';
import 'package:first_project/design/images.dart';
import 'package:flutter/material.dart';
import '../../design/dimensions.dart';

class VehicleItem extends StatelessWidget {
  const VehicleItem({super.key});

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
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(left: padding8, right: padding16),
            child: Row(
              children: <Widget>[vehicleMotorcycleImage, _title(), _state()],
            ),
          ),
        ),
      ),
    );
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
              'BMW GS-7638',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: secondaryColor,
                fontSize: fontSize14,
                fontWeight: FontWeight.w600,
              ),
            ),

            // Text(
            //   'No driver',
            // maxLines: 1,
            // overflow: TextOverflow.ellipsis,
            //   style: TextStyle(
            //     color: secondaryVariantColor,
            //     fontSize: fontSize14,
            //     fontWeight: FontWeight.w400,
            //   ),
            // ),
            RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: const TextSpan(
                style: TextStyle(fontSize: fontSize14),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Driver: ',
                    style: TextStyle(
                      color: secondaryVariantColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  TextSpan(
                    text: 'Paul',
                    style: TextStyle(
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
          const Text(
            'pickup',
            style: TextStyle(
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
