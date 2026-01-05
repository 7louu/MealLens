class Food {
  final String id;
  final String name;
  final String category;
  final double caloriesPerGram;
  final double proteinPerGram;
  final double carbsPerGram;
  final double fatPerGram;

  Food({
    required this.id,
    required this.name,
    required this.category,
    required this.caloriesPerGram,
    required this.proteinPerGram,
    required this.carbsPerGram,
    required this.fatPerGram,
  });

  factory Food.fromMap(Map<String, dynamic> data, String id) {
    return Food(
      id: id,
      name: data['name'],
      category: data['category'],
      caloriesPerGram: (data['caloriesPerGram'] as num).toDouble(),
      proteinPerGram: (data['proteinPerGram'] as num).toDouble(),
      carbsPerGram: (data['carbsPerGram'] as num).toDouble(),
      fatPerGram: (data['fatPerGram'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'caloriesPerGram': caloriesPerGram,
      'proteinPerGram': proteinPerGram,
      'carbsPerGram': carbsPerGram,
      'fatPerGram': fatPerGram,
    };
  }
}
