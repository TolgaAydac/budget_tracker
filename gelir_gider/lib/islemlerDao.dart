import 'package:sqflite/sqflite.dart';
import 'VeriTabaniYardımci.dart';
import 'islem.dart';

class IslemlerDao {
  Future<List<Islem>> tumIslemler(int kullaniciId) async {
    final db = await VeriTabaniYardimcisi.veritabaniErisim();
    final List<Map<String, dynamic>> maps = await db.query(
      'islemler',
      where: 'kisi_id = ?',
      whereArgs: [kullaniciId],
    );
    return List.generate(maps.length, (i) => Islem.fromMap(maps[i]));
  }

  Future<bool> islemEkle(Islem islem) async {
    final db = await VeriTabaniYardimcisi.veritabaniErisim();
    int id = await db.insert(
      'islemler',
      islem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (id > 0) {
      String ay = islem.tarih!.split('.')[1];
      String yil = islem.tarih!.split('.')[2];
      await db.insert('aylik_islemler', {
        'kullanici_id': islem.kisiId,
        'ay': ay,
        'yil': yil,
        'tip': islem.tipi,
        'tutar': islem.tutar,
        'aciklama': islem.aciklama,
        'tarih': islem.tarih,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    }
    return false;
  }

  Future<int> toplamTutarByTipiVeAy(
    String tipi,
    int kullaniciId,
    int ay,
    int yil,
  ) async {
    final db = await VeriTabaniYardimcisi.veritabaniErisim();
    final result = await db.query(
      'islemler',
      columns: ['tutar', 'tarih'],
      where: 'tipi = ? AND kisi_id = ?',
      whereArgs: [tipi, kullaniciId],
    );

    int toplam = 0;
    for (var row in result) {
      final tarihStr = row['tarih'] as String;
      final parts = tarihStr.split('.');
      if (parts.length == 3) {
        int rowAy = int.parse(parts[1]);
        int rowYil = int.parse(parts[2]);
        if (rowAy == ay && rowYil == yil) {
          toplam += row['tutar'] as int;
        }
      }
    }

    return toplam;
  }

  Future<int> toplamTutarByTipi(String tip, int kullaniciId) async {
    final db = await VeriTabaniYardimcisi.veritabaniErisim();
    final result = await db.rawQuery(
      'SELECT SUM(tutar) as toplam FROM islemler WHERE tipi = ? AND kisi_id = ?',
      [tip, kullaniciId],
    );
    return result[0]['toplam'] == null
        ? 0
        : (result[0]['toplam'] as num).toInt();
  }

  Future<int> toplamTutarByTipiAy(
    String tip,
    int kullaniciId,
    String ay,
    String yil,
  ) async {
    final db = await VeriTabaniYardimcisi.veritabaniErisim();
    final result = await db.rawQuery(
      'SELECT SUM(tutar) as toplam FROM aylik_islemler WHERE tip = ? AND kullanici_id = ? AND ay = ? AND yil = ?',
      [tip, kullaniciId, ay, yil],
    );
    return result[0]['toplam'] == null
        ? 0
        : (result[0]['toplam'] as num).toInt();
  }

  Future<void> islemSil(Islem islem) async {
    final db = await VeriTabaniYardimcisi.veritabaniErisim();
    await db.delete('islemler', where: 'id = ?', whereArgs: [islem.id]);
    await db.delete('aylik_islemler', where: 'id = ?', whereArgs: [islem.id]);
  }
}
