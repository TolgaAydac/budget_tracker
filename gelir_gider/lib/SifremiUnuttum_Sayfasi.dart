import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'KisilerDao.dart';

class SifremiUnuttumSayfasi extends StatefulWidget {
  const SifremiUnuttumSayfasi({super.key});

  @override
  State<SifremiUnuttumSayfasi> createState() => _SifremiUnuttumSayfasiState();
}

class _SifremiUnuttumSayfasiState extends State<SifremiUnuttumSayfasi> {
  final TextEditingController _kullaniciAdiController = TextEditingController();
  final TextEditingController _cevapController = TextEditingController();
  final TextEditingController _yeniSifreController = TextEditingController();

  String? _secilenSoru;
  bool _soruDogru = false;

  final List<String> sorular = [
    "En sevdiğiniz yemek?",
    "En sevdiğiniz renk?",
    "En sevdiğiniz sayı?",
  ];

  @override
  void dispose() {
    _kullaniciAdiController.dispose();
    _cevapController.dispose();
    _yeniSifreController.dispose();
    super.dispose();
  }

  Future<void> _kontrolEt() async {
    String kullaniciAdi = _kullaniciAdiController.text.trim();
    String secilenSoru = _secilenSoru ?? "";
    String cevap = _cevapController.text.trim();

    if (secilenSoru.isEmpty || cevap.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lütfen soru seçin ve cevabı girin!")),
      );
      return;
    }

    bool dogruMu = await KisilerDao().gizliSoruKontrolDropdown(
      kullaniciAdi,
      secilenSoru,
      cevap,
    );

    if (dogruMu) {
      setState(() {
        _soruDogru = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gizli soru doğru. Yeni şifrenizi girin.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kullanıcı adı, soru veya cevap yanlış!")),
      );
    }
  }

  Future<void> _sifreGuncelle() async {
    String kullaniciAdi = _kullaniciAdiController.text.trim();
    String yeniSifre = _yeniSifreController.text.trim();

    if (yeniSifre.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lütfen yeni şifrenizi girin!")));
      return;
    }

    bool sonuc = await KisilerDao().sifreGuncelle(kullaniciAdi, yeniSifre);

    if (sonuc) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Şifre başarıyla güncellendi!")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Şifre güncellenirken hata oluştu.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF21254A),
      appBar: AppBar(
        backgroundColor: Color(0xFF21254A),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
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
          Align(
            alignment: Alignment(0, -0.95),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Şifremi Unuttum",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 32),
                  _buildTextField(
                    "Kullanıcı Adı",
                    _kullaniciAdiController,
                    icon: Icons.person,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _secilenSoru,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF2e2b50),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Lütfen Gizli Sorunuzu Seçiniz",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                    ),
                    dropdownColor: Color(0xFF2e2b50),
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          "Lütfen Gizli Sorunuzu Seçiniz",
                          style: TextStyle(color: Colors.white60),
                        ),
                        value: null,
                      ),
                      ...sorular.map(
                        (s) => DropdownMenuItem(
                          child: Text(s, style: TextStyle(color: Colors.white)),
                          value: s,
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _secilenSoru = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    "Cevabınızı girin",
                    _cevapController,
                    icon: Icons.help_outline,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _kontrolEt,
                    child: Text(
                      "Kontrol Et",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff31274f),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  if (_soruDogru) ...[
                    SizedBox(height: 32),
                    _buildTextField(
                      "Yeni Şifre",
                      _yeniSifreController,
                      icon: Icons.lock,
                      isObscure: true,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _sifreGuncelle,
                      child: Text("Şifreyi Güncelle"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    IconData? icon,
    bool isObscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      style: TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: Colors.white60) : null,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Color(0xFF2e2b50),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
