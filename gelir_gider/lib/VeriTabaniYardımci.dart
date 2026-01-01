import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class VeriTabaniYardimcisi {
  static final String veritabaniAdi = "gelir_gider_db.sqlite";
  static Database? _db;

  static Future<Database> veritabaniErisim() async {
    if (_db != null) return _db!;

    String veritabaniYolu = join(await getDatabasesPath(), veritabaniAdi);

    // DİKKAT: Eski verileri SİLMEK İÇİN bu satırı BİR SEFERLİĞİNE aktif ediyoruz
    // await deleteDatabase(veritabaniYolu);
    // print("ESKİ VERİTABANI DOSYASI FİZİKSEL OLARAK SİLİNDİ!");

    _db = await openDatabase(
      veritabaniYolu,
      version: 1,
      onCreate: (db, version) async {
        print("Sıfır kilometre veritabanı oluşturuluyor...");

        await db.execute('''
          CREATE TABLE islemler (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tutar INTEGER NOT NULL,
            aciklama TEXT,
            tarih TEXT,
            tipi TEXT,
            kisi_id INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE "Kullanıcı Giriş" (
            kisi_id INTEGER PRIMARY KEY AUTOINCREMENT,
            kisi_ad TEXT,
            kisi_soyad TEXT,
            kisi_kullaniciadi TEXT,
            kisi_sifre TEXT,
            kisi_gizli_soru TEXT NOT NULL,
            kisi_gizli_cevap TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE aylik_islemler (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            kullanici_id INTEGER,
            ay TEXT,
            yil INTEGER,
            tip TEXT,
            tutar REAL,
            aciklama TEXT,
            tarih TEXT
          )
        ''');

        print("TÜM YENİ TABLOLAR OLUŞTURULDU.");
      },
    );
    return _db!;
  }
}
