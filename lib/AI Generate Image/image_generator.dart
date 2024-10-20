import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_generation/secrets/secrets.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stability_image_generation/stability_image_generation.dart';

class ImageGenerator extends StatefulWidget {
  const ImageGenerator({super.key});

  @override
  State<ImageGenerator> createState() => _ImageGeneratorState();
}

class _ImageGeneratorState extends State<ImageGenerator> {
  final TextEditingController _queryController = TextEditingController();
  final StabilityAI _ai = StabilityAI();
  final String apiKey = Secrets().APIKEY;
  final ImageAIStyle imageAIStyle = ImageAIStyle.digitalPainting;

  bool isItems = false;

  Future<Uint8List> _generate(String query) async {
    Uint8List image = await _ai.generateImage(
      apiKey: apiKey,
      imageAIStyle: imageAIStyle,
      prompt: query,
    );
    return image;
  }

  @override
  void dispose() {
    super.dispose();
    _queryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Text to Image",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: 55,
                  margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: _queryController,
                    decoration: const InputDecoration(
                      hintText: "Enter Prompt",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15, top: 5),
                    ),
                  ),
                ),
              ),
          
              ElevatedButton(
                onPressed: () {
                  String query = _queryController.text;
                  if (query.isNotEmpty) {
                    setState(() {
                      isItems = true;
                    });
                  } else {
                    if (kDebugMode) {
                      print('Query is Empty');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Fully rounded corners
                  ),
                  elevation: 5, // Adds a shadow for a 3D effect
                  backgroundColor: Colors.transparent, // Transparent to show gradient
                ).copyWith(
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blueAccent, Colors.cyanAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30), // Fully rounded
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: const Text(
                    "Generate Image",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          
          
              //Gradient Button
              // ElevatedButton(
              //   onPressed: () {
              //     String query = _queryController.text;
              //     if (query.isNotEmpty) {
              //       setState(() {
              //         isItems = true;
              //       });
              //     } else {
              //       if (kDebugMode) {
              //         print('Query is Empty');
              //       }
              //     }
              //   },
              //   style: ElevatedButton.styleFrom(
              //     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     elevation: 0,
              //     backgroundColor: Colors.transparent,
              //   ),
              //   child: ShaderMask(
              //     shaderCallback: (Rect bounds) {
              //       return const LinearGradient(
              //         colors: [Colors.white, Colors.grey],
              //         begin: Alignment.topLeft,
              //         end: Alignment.bottomRight,
              //       ).createShader(bounds);
              //     },
              //     blendMode: BlendMode.srcIn,
              //     child: const Text(
              //       "Generate Image",
              //       style: TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),

              Padding(
                padding: EdgeInsets.all(20),
                child: isItems
                    ? FutureBuilder<Uint8List>(
                  future: _generate(_queryController.text),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Skeletonizer(
                        child: Container(
                          width: 300,
                          height: 300,
                          color: Colors.grey[300],
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(snapshot.data!),
                      );
                    } else {
                      return const Text("Error generating image");
                    }
                  },
                )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
