class Modelicazetype{
  int? icazeId;
  String? icazeAdi;



  Modelicazetype({this.icazeId, this.icazeAdi});

  // JSON-dan obyekt yaratmaq üçün
  factory Modelicazetype.fromJson(Map<String, dynamic> json) {
    return Modelicazetype(
      icazeId: json['IcazeId'] as int?,
      icazeAdi: json['IcazeTypeName'] as String?,
    );
  }

  // Obyekti JSON-a çevirmək üçün
  Map<String, dynamic> toJson() {
    return {
      'icazeId': icazeId,
      'icazeAdi': icazeAdi,
    };
  }

  @override
  String toString() {
    return 'Modelicazetype{icazeId: $icazeId, icazeAdi: $icazeAdi}';
  }
}