import Flutter
import UIKit
import Vision

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "BamiHandwritingRecognizer") {
      HandwritingChannel.register(with: registrar)
    }
  }
}

/// Nhận dạng chữ viết tay (bảng vẽ chép chính tả) bằng Vision, chạy hoàn toàn trên máy.
/// Dart: lib/core/handwriting/handwriting_recognizer.dart – kênh "bami/handwriting", hàm "recognize" nhận ảnh PNG.
private enum HandwritingChannel {
  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "bami/handwriting", binaryMessenger: registrar.messenger())
    channel.setMethodCallHandler { call, result in
      guard call.method == "recognize",
            let args = call.arguments as? [String: Any],
            let png = (args["png"] as? FlutterStandardTypedData)?.data
      else {
        result(FlutterMethodNotImplemented)
        return
      }
      DispatchQueue.global(qos: .userInitiated).async {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en-US"]
        request.usesLanguageCorrection = true
        do {
          try VNImageRequestHandler(data: png, options: [:]).perform([request])
          // Gốc toạ độ Vision ở góc dưới trái: dòng trên có midY lớn hơn. Cùng dòng thì trái → phải.
          let lines = (request.results ?? []).sorted { a, b in
            let dy = a.boundingBox.midY - b.boundingBox.midY
            if abs(dy) > min(a.boundingBox.height, b.boundingBox.height) / 2 { return dy > 0 }
            return a.boundingBox.minX < b.boundingBox.minX
          }
          let text = lines.compactMap { $0.topCandidates(1).first?.string }.joined(separator: " ")
          DispatchQueue.main.async { result(text) }
        } catch {
          DispatchQueue.main.async {
            result(FlutterError(code: "vision", message: error.localizedDescription, details: nil))
          }
        }
      }
    }
  }
}
