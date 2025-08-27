import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gelir_gider/KisilerDao.dart';
import 'package:gelir_gider/main.dart';

class HesapOlustur extends StatefulWidget {
  const HesapOlustur({super.key});

  @override
  State<HesapOlustur> createState() => _HesapOlusturState();
}

class _HesapOlusturState extends State<HesapOlustur> {
  final adController = TextEditingController();
  final soyadController = TextEditingController();
  final kullaniciAdiController = TextEditingController();
  final sifreController = TextEditingController();
  final gizliCevapController = TextEditingController();

  bool _sifreGoster = false;

  final FocusNode _adFocus = FocusNode();
  final FocusNode _soyadFocus = FocusNode();
  final FocusNode _kullaniciAdiFocus = FocusNode();
  final FocusNode _sifreFocus = FocusNode();
  final FocusNode _gizliSoruFocus = FocusNode();

  String? secilenSoru;

  @override
  void dispose() {
    _adFocus.dispose();
    _soyadFocus.dispose();
    _kullaniciAdiFocus.dispose();
    _sifreFocus.dispose();
    _gizliSoruFocus.dispose();

    adController.dispose();
    soyadController.dispose();
    kullaniciAdiController.dispose();
    sifreController.dispose();
    gizliCevapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(""),
        backgroundColor: Color(0xFF21254A),
        elevation: 0,
      ),
      backgroundColor: Color(0xFF21254A),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Hesap Oluştur",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),
                  _buildTextField(
                    "Ad",
                    adController,
                    _adFocus,
                    _soyadFocus,
                    Icons.person,
                  ),
                  customSizedBox(),
                  _buildTextField(
                    "Soyad",
                    soyadController,
                    _soyadFocus,
                    _kullaniciAdiFocus,
                    Icons.person,
                  ),
                  customSizedBox(),
                  _buildTextField(
                    "Kullanıcı Adı",
                    kullaniciAdiController,
                    _kullaniciAdiFocus,
                    _sifreFocus,
                    Icons.verified_user,
                  ),
                  customSizedBox(),
                  _buildTextField(
                    "Şifre",
                    sifreController,
                    _sifreFocus,
                    _gizliSoruFocus,
                    Icons.password_sharp,
                    isPassword: true,
                  ),
                  customSizedBox(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: secilenSoru,
                        decoration: InputDecoration(
                          hintText: "Gizli Soru Seçiniz",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Color(0xFF2e2b50),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        dropdownColor: Color(0xFF2e2b50),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(
                              "Lütfen Gizli Sorunuzu Seçiniz",
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "En sevdiğiniz yemek?",
                            child: Text(
                              "En sevdiğiniz yemek?",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "En sevdiğiniz renk?",
                            child: Text(
                              "En sevdiğiniz renk?",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "En sevdiğiniz sayı?",
                            child: Text(
                              "En sevdiğiniz sayı?",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                        onChanged: (deger) {
                          setState(() {
                            secilenSoru = deger;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: gizliCevapController,
                        decoration: InputDecoration(
                          hintText: "Cevabınızı girin",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Color(0xFF2e2b50),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  customSizedBox(),
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        String ad = adController.text.trim();
                        String soyad = soyadController.text.trim();
                        String kullaniciAdi = kullaniciAdiController.text
                            .trim();
                        String sifre = sifreController.text.trim();
                        String? gizliSoru = secilenSoru;
                        String gizliCevap = gizliCevapController.text.trim();

                        if (ad.isEmpty ||
                            soyad.isEmpty ||
                            kullaniciAdi.isEmpty ||
                            sifre.isEmpty ||
                            gizliSoru == null ||
                            gizliCevap.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Lütfen tüm alanları doldurun!"),
                            ),
                          );
                          return;
                        }

                        bool sonuc = await KisilerDao().kullaniciEkle(
                          ad,
                          soyad,
                          kullaniciAdi,
                          sifre,
                          gizliSoru,
                          gizliCevap,
                        );

                        if (sonuc) {
                          var yeniKullanici = await KisilerDao()
                              .getSonEklenenKullanici();
                          aktifKullaniciId = yeniKullanici.kisi_id;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Kayıt başarılı!")),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Kayıt başarısız!")),
                          );
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(0xff31274f),
                        ),
                        child: Center(
                          child: Text(
                            "Oluştur",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.rotate(
              angle: 3.14,
              child: Image.asset(
                "resimler/topImage.png",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customSizedBox() => SizedBox(height: 20);

  Widget _buildTextField(
    String hint,
    TextEditingController controller,
    FocusNode focusNode,
    FocusNode? nextFocus,
    IconData icon, {
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: nextFocus != null
          ? TextInputAction.next
          : TextInputAction.done,
      obscureText: isPassword ? !_sifreGoster : false,
      style: TextStyle(color: Colors.white),
      maxLength: isPassword ? 4 : null,
      keyboardType: isPassword ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Color(0xFF2e2b50),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _sifreGoster ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey[400],
                ),
                onPressed: () {
                  setState(() {
                    _sifreGoster = !_sifreGoster;
                  });
                },
              )
            : null,
        counterStyle: TextStyle(color: Colors.grey[400]),
      ),
      inputFormatters: isPassword
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      onFieldSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
    );
  }
}
