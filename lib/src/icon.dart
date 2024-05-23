import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:i_player/src/theme.dart';

class IplayerIcon extends StatelessWidget {
  final IconSourceData data;
  final double size;
  const IplayerIcon({super.key, required this.data, required this.size});

  @override
  Widget build(BuildContext context) {
    if(data.icon != null){
      return Icon(
        data.icon,
        size: size,
        color: data.color,
      );
    }
    if(data.svgAsset != null){
      return SvgPicture.asset(
        data.svgAsset!,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(
          data.color,
          BlendMode.srcIn,
        ),
      );
    }
    if(data.imageAsset != null){
      return Image.asset(
        data.imageAsset!,
        width: size,
        height: size,
      );
    }
    return Icon(
      Icons.error_outline,
      color: Colors.red,
      size: size,
    );
  }
}
