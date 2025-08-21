import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class VeriTabaniYardimcisi {
  static final String veritabaniAdi = "gelir_gider_db.sqlite";

  static Future<Database> veritabaniErisim() async {
    String veritabaniYolu = join(await getDatabasesPath(), veritabaniAdi);
    

    return openDatabase(
      veritabaniYolu,
      version: 1,
      onCreate: (db, version) async {
        print("Veritabanı oluşturuluyor...");

        await db.execute('''
          CREATE TABLE islemler (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tutar INTEGER NOT NULL,
            aciklama TEXT,
            tarih TEXT,
            tipi TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE "Kullanıcı Giriş" (
            kisi_id INTEGER PRIMARY KEY AUTOINCREMENT,
            kisi_ad TEXT,
            kisi_soyad TEXT,
            kisi_kullaniciadi TEXT,
            kisi_sifre TEXT,
            kisi_gizli_soru TEXT NOT NULL
          )
        ''');

        print("Tablolar oluşturuldu.");
      },
    );
  }
}
