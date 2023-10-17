
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:functior/components/arg_tile.dart';
import 'package:functior/models/args_asker.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/arg.dart';


class ToParticles extends StatefulWidget {
  const ToParticles({super.key});

  @override
  State<ToParticles> createState() => _ToParticlesState();
}

class _ToParticlesState extends State<ToParticles> {

  void startGenerate(BuildContext context, List<Arg> argList) {
    final samplingRate = 
      double.tryParse(argList[0].controller.text) ?? argList[0].defaultValue;
    final particleHeight =
      double.tryParse(argList[1].controller.text) ?? argList[1].defaultValue;
    final particleTypeId =
      argList[2].controller.text.isEmpty ?
      argList[2].defaultValue :
      argList[2].controller.text;
    final targetColor = 
      argList[3].controller.text.isEmpty ?
      argList[3].defaultValue :
      argList[3].controller.text;
    final generationSurface =
      argList[4].controller.text.isEmpty ?
      argList[4].defaultValue :
      argList[4].controller.text;
    // !
    if (
      !validationCheck(
        context,
        samplingRate,
        particleHeight,
        particleTypeId,
        targetColor,
        generationSurface
      )
    ) return;

    // *
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: generate(context, [
            samplingRate,
            particleHeight,
            particleTypeId,
            hexToRgb(targetColor),
            generationSurface
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AlertDialog(
                title: Row(children: [
                  Text('Loading'),
                  Icon(Icons.bolt)
                ]),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator()
                  ]
                )
              );
            } else if (snapshot.hasError) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('${snapshot.error}'),
              );
            } else {
              return AlertDialog(
                title: const Row(children: [
                  Text('Done'),
                  Icon(Icons.done_all)
                ]),
                content: Text('Saved function to:\n${snapshot.data}'),
              );
            }
          }
        );
      }
    );
  }

  Future<String> generate(BuildContext context, List argList) async {
    // *
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']
    );

    // !
    if (result == null) {
      throw Exception('No file has picked');
    }

    final filePath = result.files.single.path ?? '';
    final imageFile = File(filePath);
    final bytes = await imageFile.readAsBytes();
    final decodedImage = img.decodeImage(bytes);

    // !
    if (decodedImage == null) {
      throw Exception('Something wrong with your image');
    }

    // Arguments
    final width = decodedImage.width;
    final height = decodedImage.height;
    final step = 1 / argList[0];
    final zoomCoefficient = argList[1] / height;
    final particleTypeId = argList[2];
    final rgbs = argList[3];
    final surface = argList[4];
    final targetR = rgbs[0];
    final targetG = rgbs[1];
    final targetB = rgbs[2];

    late final appDataDir;
    if (Platform.isAndroid) {
      appDataDir = await getExternalStorageDirectory();
    } else {
      appDataDir = await getApplicationDocumentsDirectory();
    }

    var output = StringBuffer();
    late File outputFile;
    var fileIndex = 0;
    var linesCount = 0;

    // Pixel traversal
    for (int x = 0; x < width; x += step.toInt()) {
      for (int y = 0; y < height; y += step.toInt()) {
        final pixel = decodedImage.getPixel(x.toInt(), y.toInt());

        final r = img.getRed(pixel);
        final g = img.getGreen(pixel);
        final b = img.getBlue(pixel);

        final distance = sqrt(
          pow(targetR - r, 2) + pow(targetG - g, 2) + pow(targetB - b, 2)
        );

        if (distance > 30) continue;

        final transX = (width / 2 - x) * zoomCoefficient;
        final transY = (height / 2 - y) * zoomCoefficient;

        // Write
        if (surface == 'xOy') {
          output.write('particle $particleTypeId ~$transX ~$transY ~\n');
        } else if (surface == 'xOz') {
          output.write('particle $particleTypeId ~$transX ~ ~$transY\n');
        } else if (surface == 'yOz') {
          output.write('particle $particleTypeId ~ ~$transX ~$transY\n');
        } else {
          throw Exception('Unknown error occured'); 
        }

        // Maximum lines cutting
        linesCount++;
        if (linesCount >= 10000) {
          final savePath = path.join(
            appDataDir.absolute.path,
            'output$fileIndex.mcfunction'
          );
          outputFile = File(savePath);
          await outputFile.writeAsString(output.toString());
          // Updates
          output = StringBuffer();
          linesCount = 0;
          fileIndex++;
        }
      }
    }

    // Rest
    final savePath = path.join(appDataDir.absolute.path, 'output$fileIndex.mcfunction');
    outputFile = File(savePath);
    await outputFile.writeAsString(output.toString());
    // Done
    return savePath;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ArgsAsker>(
      builder: (context, value, child) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(children: [
            const Text(
              'Functior',
              style: TextStyle(fontSize: 36),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: ListView.builder(
                itemCount: value.toParticlesArgs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: TextArgTile(
                      arg: value.toParticlesArgs[index],
                    )
                  );
                }
              ),
            ),
            const SizedBox(height: 25),
            Column(
              children: [
                GestureDetector(
                  onTap: () => startGenerate(context, value.toParticlesArgs),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: const Center(
                      child: Text(
                        'Generate',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ]),
        ),
      )
    );
  }
}

bool validationCheck(
  BuildContext context,
  double samplingRate,
  double particleHeight,
  String particleTypeId,
  String targetColor,
  String generationSurface
) {
  //
  if (samplingRate < 0 || samplingRate > 1) {
    alertInvalidArg(context, 'Sampling Rate');
    return false;
  }
  //
  if (particleHeight < 0) {
  alertInvalidArg(context, 'Particle Height');
    return false;
  }
  //
  if (particleTypeId.isEmpty) {
    alertInvalidArg(context, 'Particle TypeId');
    return false;
  }
  //
  if (hexToRgb(targetColor).isEmpty) {
    alertInvalidArg(context, 'Target Color');
    return false;
  }
  //
  if (!['xOy', 'xOz', 'yOz'].contains(generationSurface)) {
    alertInvalidArg(context, 'Generation Surface');
    return false;
  }
  //
  return true;
}

void alertInvalidArg(BuildContext context, String arg) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Argument error'),
        content: Text(
          "Invalid argument '$arg'" + '\n' +
          'Click the button next to the argument name to see more infomation about this argument'
        ),
      )
  );
}

void alertRuntimeError(BuildContext context, String content) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Runtime error'),
        content: Text(content),
      )
  );
}

List<int> hexToRgb(String hexColor) {
  if (hexColor.startsWith('#')) {
    hexColor = hexColor.substring(1);
  }

  if (hexColor.length != 6 && hexColor.length != 8) {
    return [];
  }

  int intValue = int.parse(hexColor, radix: 16);

  if (hexColor.length == 6) {
    return [
      (intValue >> 16) & 0xFF,
      (intValue >> 8) & 0xFF,
      intValue & 0xFF,
    ];
  } else {
    return [
      (intValue >> 24) & 0xFF,
      (intValue >> 16) & 0xFF,
      (intValue >> 8) & 0xFF,
      intValue & 0xFF,
    ];
  }
}