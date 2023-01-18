import 'package:flutter/foundation.dart';
import 'package:pytorch_mobile/enums/dtype.dart';
import 'package:pytorch_mobile/model.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:pytorch_mobile/pytorch_mobile.dart';

Future<List?> predict(Uint8List audioBytes) async {
  int sampleRate = 16000;
  int size = 10;
  TensorAudio tensorAudio =
      TensorAudio.create(TensorAudioFormat.create(1, sampleRate), size);
  tensorAudio.loadShortBytes(audioBytes);

  TensorBuffer inputBuffer = tensorAudio.tensorBuffer;

  // loading model from assets
  String path_to_model = 'assets/models/custom_model.pt';

  Model customModel = await PyTorchMobile.loadModel(path_to_model);
  List<dynamic>? prediction = await customModel.getPrediction(
      inputBuffer.getDoubleList(), [sampleRate * size], DType.float32);

  return prediction;
}
