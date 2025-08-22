import 'package:flutter/material.dart';
import 'package:gelir_gider/Gider.dart';
import 'package:gelir_gider/gunceldurum.dart';
import 'Gelir.dart';
import 'aylik_ozet.dart';
import 'dart:io'; // exit(0) için

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  var sayfaListesi = [
    Gelir_Sayfasi(),
    gunceldurum(),
    Gider_Sayfasi(),
    AylikOzetSayfasi(),
  ];

  int secilenIndeks = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF21254A),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 185,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("resimler/topImage.png"),
                  ),
                ),
              ),
              Positioned(
                top: 55,
                left: 10,
                child: IconButton(
                  icon: Icon(
                    Icons.keyboard_return_outlined,
                    color: Color(0xFF21254A),
                    size: 30,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Color(0xFF21254A),
                        title: Text(
                          "Çıkış Yap",
                          style: TextStyle(color: Colors.white),
                        ),
                        content: Text(
                          "Uygulamadan çıkmak istediğinize emin misiniz?",
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "İptal",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              exit(0);
                            },
                            child: Text(
                              "Çıkış",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Expanded(child: sayfaListesi[secilenIndeks]),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          splashColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              label: "Gelirlerim",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: "Durumum",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_down),
              label: "Giderlerim",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pending_actions),
              label: "Aylık Özet",
            ),
          ],
          backgroundColor: Color(0xFF21254A),
          unselectedItemColor: Colors.white30,
          selectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 16,
          unselectedFontSize: 16,
          iconSize: 45,
          elevation: 0,
          currentIndex: secilenIndeks,
          onTap: (indeks) {
            setState(() {
              secilenIndeks = indeks;
            });
          },
        ),
      ),
    );
  }
}
