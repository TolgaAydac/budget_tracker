import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class VeriTabaniYardimcisi {
  static final String veritabaniAdi = "gelir_gider_db.sqlite";

  static Future<Database> veritabaniErisim() async {
    String veritabaniYolu = join(await getDatabasesPath(), veritabaniAdi);

    return openDatabase(
      veritabaniYolu,
      version: 2,
      onCreate: (db, version) async {
        print("Veritabanı oluşturuluyor...");
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

        print("Tablolar oluşturuldu.");
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE islemler ADD COLUMN kisi_id INTEGER DEFAULT 0',
          );
          await db.execute(
            'ALTER TABLE "Kullanıcı Giriş" ADD COLUMN kisi_gizli_cevap TEXT NOT NULL DEFAULT ""',
          );
          print("Tablolar upgrade edildi.");
        }
      },
    );
  }
}
