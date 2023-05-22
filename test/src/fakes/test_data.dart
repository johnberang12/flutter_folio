class TestData {
  final String id;
  TestData({
    required this.id,
  });

  TestData copyWith({
    String? id,
  }) {
    return TestData(
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
    };
  }

  factory TestData.fromMap(Map<String, dynamic> map) {
    return TestData(
      id: map['id'] as String,
    );
  }

  @override
  bool operator ==(covariant TestData other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
