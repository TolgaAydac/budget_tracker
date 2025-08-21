import 'package:gelir_gider/Kullaniciler.dart';
import 'package:gelir_gider/VeriTabaniYard%C4%B1mci.dart';

class KisilerDao {
  Future<List<Kullaniciler>> tumKullaniciler() async {
    var db = await VeriTabaniYardimcisi.veritabaniErisim();

    List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM "Kullanıcı Giriş"',
    );

    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Kullaniciler(
        satir["kisi_id"],
        satir["kisi_ad"] ?? "",
        satir["kisi_soyad"] ?? "",
        satir["kisi_kullaniciadi"] ?? "",
        satir["kisi_sifre"] ?? "",
        satir["kisi_gizli_soru"] ?? "",
      );
    });
  }

  Future<bool> kullaniciEkle(
    String ad,
    String soyad,
    String kullaniciAdi,
    String sifre,
    String gizliSoru,
  ) async {
    var db = await VeriTabaniYardimcisi.veritabaniErisim();

    try {
      await db.insert('"Kullanıcı Giriş"', {
        'kisi_ad': ad,
        'kisi_soyad': soyad,
        'kisi_kullaniciadi': kullaniciAdi,
        'kisi_sifre': sifre,
        'kisi_gizli_soru': gizliSoru,
      });
      return true;
    } catch (e) {
      print("Kayıt sırasında hata: $e");
      return false;
    }
  }

  Future<bool> kullaniciKontrol(String kullaniciAdi, String sifre) async {
    var db = await VeriTabaniYardimcisi.veritabaniErisim();

    List<Map<String, dynamic>> sonuc = await db.query(
      '"Kullanıcı Giriş"',
      where: 'kisi_kullaniciadi = ? AND kisi_sifre = ?',
      whereArgs: [kullaniciAdi, sifre],
    );

    return sonuc.isNotEmpty;
  }

  Future<bool> gizliSoruKontrol(String kullaniciAdi, String gizliSoru) async {
    var db = await VeriTabaniYardimcisi.veritabaniErisim();

    List<Map<String, dynamic>> sonuc = await db.query(
      '"Kullanıcı Giriş"',
      where: 'kisi_kullaniciadi = ? AND kisi_gizli_soru = ?',
      whereArgs: [kullaniciAdi, gizliSoru],
    );

    return sonuc.isNotEmpty;
  }

  Future<bool> sifreGuncelle(String kullaniciAdi, String yeniSifre) async {
    var db = await VeriTabaniYardimcisi.veritabaniErisim();

    try {
      int count = await db.update(
        '"Kullanıcı Giriş"',
        {'kisi_sifre': yeniSifre},
        where: 'kisi_kullaniciadi = ?',
        whereArgs: [kullaniciAdi],
      );
      return count > 0;
    } catch (e) {
      print("Şifre güncellenirken hata: $e");
      return false;
    }
  }
}
