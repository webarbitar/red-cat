// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
//
// class CustomNetworkImage extends StatelessWidget {
//   final String url;
//   final double? height;
//   final double? width;
//   final BoxFit fit;
//
//   const CustomNetworkImage({
//     Key? key,
//     required this.url,
//     this.height,
//     this.width,
//     this.fit = BoxFit.cover,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Image(
//       height: height,
//       width: width,
//       image: ResizeImage(
//         CachedNetworkImageProvider(url),
//         height: height?.toInt(),
//         width: width?.toInt(),
//       ),
//       errorBuilder: (context, url, error) {
//         return SizedBox(
//           height: height,
//           child: const Center(
//             child: Text("No image"),
//           ),
//         );
//       },
//       fit: fit,
//     );
//   }
// }
