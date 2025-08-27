class Kullaniciler {
  final int kisi_id;
  final String kisi_ad;
  final String kisi_soyad;
  final String kisi_kullaniciadi;
  final String kisi_sifre;
  final String kisi_gizli_soru;
  final String cevap;

  Kullaniciler(
    this.kisi_id,
    this.kisi_ad,
    this.kisi_soyad,
    this.kisi_kullaniciadi,
    this.kisi_sifre,
    this.kisi_gizli_soru,
    this.cevap,
  );

  factory Kullaniciler.fromMap(Map<String, dynamic> map) {
    return Kullaniciler(
      map['kisi_id'],
      map['kisi_ad'],
      map['kisi_soyad'],
      map['kisi_kullaniciadi'],
      map['kisi_sifre'],
      map['kisi_gizli_soru'],
      map['kisi_gizli_cevap'],
    );
  }
}
