import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gelir_gider/KisilerDao.dart';

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
  final gizliSoruController = TextEditingController();

  bool _sifreGoster = false;

  final FocusNode _adFocus = FocusNode();
  final FocusNode _soyadFocus = FocusNode();
  final FocusNode _kullaniciAdiFocus = FocusNode();
  final FocusNode _sifreFocus = FocusNode();
  final FocusNode _gizliSoruFocus = FocusNode();

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
    gizliSoruController.dispose();
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
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
                  customSizedBox(),
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
                  _buildTextField(
                    "Gizli Soru",
                    gizliSoruController,
                    _gizliSoruFocus,
                    null,
                    Icons.help_outline,
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
                        String gizliSoru = gizliSoruController.text.trim();

                        if (ad.isEmpty ||
                            soyad.isEmpty ||
                            kullaniciAdi.isEmpty ||
                            sifre.isEmpty ||
                            gizliSoru.isEmpty) {
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
                        );

                        if (sonuc) {
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
        hintStyle: TextStyle(color: Colors.grey),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _sifreGoster ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _sifreGoster = !_sifreGoster;
                  });
                },
              )
            : null,
        counterStyle: TextStyle(color: Colors.grey),
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
