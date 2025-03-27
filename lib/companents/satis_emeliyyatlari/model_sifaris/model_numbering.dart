import 'package:hive/hive.dart';

part 'model_numbering.g.dart'; // Hive kod generasiyası üçün

@HiveType(typeId: 42) // Unikal typeId olmalıdır
class Numbering extends HiveObject {
  @HiveField(0)
  int id; // Avtomatik artan ID

  @HiveField(1)
  int number; // NM_NO - Faktura nömrəsi

  @HiveField(2)
  int type; // NM_TYPE - Sənəd tipi

  Numbering({required this.id, required this.number, required this.type});
}

// // Hive üçün Adapter qeydiyyatı
// void registerAdapters() {
//   Hive.registerAdapter(NumberingAdapter());
// }

class NumberingService {
  // Hive bazasına məlumat əlavə etmək
  Future<void> addNumbering(int number, int type) async {
    final box = await Hive.openBox<Numbering>('numberingBox');
    final newNumbering = Numbering(id: box.length + 1, number: number, type: type);
    await box.add(newNumbering);
  }

  // Son nömrəni almaq (ən böyük NM_NO)
  Future<int> getLastNumber(int type) async {
    final box = await Hive.openBox<Numbering>('numberingBox');
    final numbers = box.values.where((n) => n.type == type);
    return numbers.isNotEmpty ? numbers.map((n) => n.number).reduce((a, b) => a > b ? a : b) + 1 : 1;
  }
}
