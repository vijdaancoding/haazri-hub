class DetectionResult {
  final List<String> detectedObjects;

  DetectionResult({required this.detectedObjects});

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(
      detectedObjects: List<String>.from(json['detected_objects']),
    );
  }
}