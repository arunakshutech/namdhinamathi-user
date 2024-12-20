import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullImagePreview extends StatelessWidget {
  final String imageUrl;
  const FullImagePreview({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.sizeOf(context).width,
          child: InteractiveViewer(
            child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.contain,)
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.close, color: Colors.white,),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),
        )
      ],
    ));
  }
}