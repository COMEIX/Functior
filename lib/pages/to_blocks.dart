import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:functior/components/arg_tile.dart';
import 'package:functior/models/arg_asker.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/Arg.dart';
import '../static/Colors.dart';
import 'package:window_manager/window_manager.dart';

class ToBlocks extends StatefulWidget {
  const ToBlocks({super.key});

  @override
  State<ToBlocks> createState() => _ToBlocksState();
}

class _ToBlocksState extends State<ToBlocks> {
  void startGenerate(BuildContext context, List<Arg> argList) {
    final samplingRate = double.tryParse(argList[0].controller.text) ?? argList[0].defaultValue;
    final generationSurface =
        argList[1].controller.text.isEmpty ? argList[1].defaultValue : argList[1].controller.text;
    final allowSand =
        argList[2].controller.text.isEmpty ? argList[2].defaultValue : argList[2].controller.text;
    final allowGlass =
        argList[3].controller.text.isEmpty ? argList[3].defaultValue : argList[3].controller.text;

    // !
    if (!validationCheck(context, samplingRate, generationSurface, allowSand, allowGlass)) return;

    // *
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder(
              future: generate(context, [
                samplingRate,
                generationSurface,
                allowSand == 'true' ? true : false,
                allowGlass == 'true' ? true : false
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const AlertDialog(
                      title: Row(children: [Text('Loading'), Icon(Icons.bolt)]),
                      content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [CircularProgressIndicator()]));
                } else if (snapshot.hasError) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: Text('${snapshot.error}'),
                  );
                } else {
                  return AlertDialog(
                    title: const Row(children: [Text('Done'), Icon(Icons.done_all)]),
                    content: Text('Saved function to:\n${snapshot.data}'),
                  );
                }
              });
        });
  }

  Future<String> generate(BuildContext context, List argList) async {
    // *
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']);

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
    final String surface = argList[1];
    final bool allowSand = argList[2];
    final bool allowGlass = argList[3];

    // Dir
    late final Directory appDataDir;
    if (Platform.isAndroid) {
      appDataDir = (await getExternalStorageDirectory())!;
    } else {
      appDataDir = await getApplicationDocumentsDirectory();
    }

    // Traversal
    var output = StringBuffer();
    late File outputFile;
    var fileIndex = 0;
    var linesCount = 0;

    final transWidth = width / step;
    final transHeight = height / step;
    double relativeX = 0;
    double relativeY = 0;
    for (int x = 0; x < width; x += step.toInt()) {
      for (int y = 0; y < height; y += step.toInt()) {
        final pixel = decodedImage.getPixel(x.toInt(), y.toInt());

        final r = img.getRed(pixel);
        final g = img.getGreen(pixel);
        final b = img.getBlue(pixel);

        final transX = transWidth / 2 - relativeX;
        final transY = transHeight / 2 - relativeY;

        // Search for a block in palette
        var minRgbDistance = double.infinity;
        var blockTypeId;
        var blockState;
        for (final color in palette) {
          // Filter
          if (!allowSand && color['name'].contains('sand')) {
            continue;
          }
          if (!allowGlass && color['name'].contains('glass')) {
            continue;
          }
          // Cal distance
          final distance = pow(color['rgb'][0] - r, 2) +
              pow(color['rgb'][1] - g, 2) +
              pow(color['rgb'][2] - b, 2);

          if (distance >= minRgbDistance) continue;

          blockTypeId = color['name'];
          minRgbDistance = distance.toDouble();

          if (color['state'] == null) {
            blockState = null;
            continue;
          }

          blockState = color['state'];
        }

        // If has BlockState
        var command;
        if (surface == 'xOy') {
          command = 'setblock ~$transX ~$transY ~ $blockTypeId ';
        }
        if (surface == 'xOz') {
          command = 'setblock ~$transX ~ ~$transY $blockTypeId ';
        }
        if (surface == 'yOz') {
          command = 'setblock ~ ~$transX ~$transY $blockTypeId ';
        }

        if (blockState != null) {
          final key = blockState.keys.toList()[0];
          command += '["$key"="${blockState[key]}"]';
          command += '\n';
          output.write(command);
        } else {
          command += '\n';
          output.write(command);
        }

        // Stepping
        relativeY += 1;
        // Maximum lines cutting
        linesCount++;
        if (linesCount >= 10000) {
          final savePath = path.join(appDataDir.absolute.path, 'output$fileIndex.mcfunction');
          outputFile = File(savePath);
          await outputFile.writeAsString(output.toString());
          // Updates
          output = StringBuffer();
          linesCount = 0;
          fileIndex++;
        }
      }
      relativeY = 0;
      relativeX++;
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
    return GestureDetector(
      onPanStart: (details) {
        if (Platform.isWindows) windowManager.startDragging();
      },
      child: Consumer<ArgsAsker>(
        builder: (context, value, child) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Functior',
                      style: TextStyle(
                        fontFamily: "PingFang SC",
                        fontSize: 36,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: ListView.builder(
                    itemCount: value.toBlocksArgs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: TextArgTile(
                          arg: value.toBlocksArgs[index],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () => startGenerate(context, value.toBlocksArgs),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Generate',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "PingFang SC",
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool validationCheck(BuildContext context, double samplingRate, String generationSurface,
    String allowSand, String allowGlass) {
  //
  if (samplingRate < 0 || samplingRate > 1) {
    alertInvalidArg(context, 'Sampling Rate');
    return false;
  }
  //
  if (!['xOy', 'xOz', 'yOz'].contains(generationSurface)) {
    alertInvalidArg(context, 'Generation Surface');
    return false;
  }
  //
  if (!['true', 'false'].contains(allowSand)) {
    alertInvalidArg(context, 'Allow Sand');
    return false;
  }
  //
  if (!['true', 'false'].contains(allowGlass)) {
    alertInvalidArg(context, 'Allow Glass');
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
        "Invalid argument '$arg'"
        '\n'
        'Click the button next to the argument name to see more infomation about this argument',
      ),
    ),
  );
}
