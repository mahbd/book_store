import 'package:flutter/material.dart';

class FutureImage extends StatelessWidget {
  const FutureImage({Key? key, required this.url}) : super(key: key);
  final String url;

  Future<Image> _getImage() async {
    final image = Image.network(
      url,
      fit: BoxFit.cover,
    );
    await Future.delayed(const Duration(microseconds: 500), () {
      return image;
    });
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getImage(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return convertObjecToImage(snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}

Image convertObjecToImage(Object object) {
  return object as Image;
}
