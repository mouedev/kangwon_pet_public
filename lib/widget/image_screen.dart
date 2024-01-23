import 'package:flutter/material.dart';
import 'package:kangwon_pet/provider.dart';
import 'package:provider/provider.dart';

import '../model/detail_data_of_content.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DetailDataOfContent? detailDataOfContent = context.select(
        (MainProvider mainProvider) => mainProvider.detailSequencePartData);

    if (detailDataOfContent == null) {
      return const Center(child: Text("정보가 없습니다."));
    }

    String imagePath = detailDataOfContent.imageList.first;

    return Scaffold(
        body: Center(
      child: InkWell(
          onDoubleTap: () {
            Navigator.pop(context);
          },
          child: Stack(
            children: [
              InteractiveViewer(
                child: SizedBox.expand(
                  child: Image.network(imagePath, fit: BoxFit.contain),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(5, 35, 0, 0),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          )),
    ));
  }
}
