import 'package:flutter/material.dart';
import 'package:gelir_gider/main.dart';
import 'package:intl/intl.dart';
import 'islemlerDao.dart';
import 'islem.dart';

class AylikOzetSayfasi extends StatefulWidget {
  const AylikOzetSayfasi({super.key});

  @override
  State<AylikOzetSayfasi> createState() => _AylikOzetSayfasiState();
}

class _AylikOzetSayfasiState extends State<AylikOzetSayfasi> {
  Map<String, List<Islem>> aylikIslemler = {};
  final formatter = NumberFormat.decimalPattern('tr_TR');
  final List<String> aylar = [
    "Ocak",
    "Şubat",
    "Mart",
    "Nisan",
    "Mayıs",
    "Haziran",
    "Temmuz",
    "Ağustos",
    "Eylül",
    "Ekim",
    "Kasım",
    "Aralık",
  ];

  @override
  void initState() {
    super.initState();
    _verileriYukle();
  }

  Future<void> _verileriYukle() async {
    final tumIslemler = await IslemlerDao().tumIslemler(aktifKullaniciId);

    Map<String, List<Islem>> temp = {};

    for (var i in tumIslemler) {
      if (i.tarih == null) continue;
      var parcalar = i.tarih!.split('.');
      if (parcalar.length != 3) continue;

      int ayIndex = int.tryParse(parcalar[1]) ?? 1;
      String ayYil = "${aylar[ayIndex - 1]} ${parcalar[2]}";

      if (!temp.containsKey(ayYil)) {
        temp[ayYil] = [];
      }
      temp[ayYil]!.add(i);
    }

    setState(() {
      aylikIslemler = temp;
    });
  }

  int _ayKarZarari(List<Islem> islemler) {
    int toplam = 0;
    for (var i in islemler) {
      if (i.tipi == "Gelir") {
        toplam += i.tutar;
      } else if (i.tipi == "Gider") {
        toplam -= i.tutar;
      }
    }
    return toplam;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF21254A),
      body: aylikIslemler.isEmpty
          ? Center(
              child: Text(
                "Henüz işlem yok",
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
            )
          : ListView(
              padding: EdgeInsets.symmetric(vertical: 8),
              children: aylikIslemler.keys.map((ay) {
                int karZarar = _ayKarZarari(aylikIslemler[ay]!);
                return Card(
                  color: Color(0xff31274f),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      title: Text(
                        ay,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        karZarar >= 0
                            ? "Kâr: ${formatter.format(karZarar)} ₺"
                            : "Zarar: ${formatter.format(karZarar.abs())} ₺",
                        style: TextStyle(
                          color: karZarar >= 0
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      children: aylikIslemler[ay]!.map((islem) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.white10),
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              islem.aciklama ?? "-",
                              style: TextStyle(color: Colors.white70),
                            ),
                            trailing: Text(
                              "${islem.tipi == "Gelir" ? "+" : "-"}${formatter.format(islem.tutar)} ₺",
                              style: TextStyle(
                                color: islem.tipi == "Gelir"
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
