import 'package:batikalongan_mobile/article/widgets/edit_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ArtikelEditScreen extends StatefulWidget {
  final int id;
  final String initialJudul;
  final String initialPendahuluan;
  final String initialKonten;
  final String initialImage;

  const ArtikelEditScreen({
    Key? key,
    required this.id,
    required this.initialJudul,
    required this.initialPendahuluan,
    required this.initialKonten,
    required this.initialImage,
  }) : super(key: key);

  @override
  _ArtikelEditScreenState createState() => _ArtikelEditScreenState();
}

class _ArtikelEditScreenState extends State<ArtikelEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Container(
          width: double.infinity,
          height: 110,
          color: Colors.white,
          padding:
              const EdgeInsets.only(top: 32, bottom: 16, left: 16, right: 16),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.start, 
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  'assets/images/back.svg', 
                  height: 40,
                  width: 40,
                ),
                onPressed: () {
                  Navigator.pop(context); 
                },
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 12.0), 
                child: Text(
                  'Edit Artikel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontFamily: 'Fabled',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: EditForm(
          id: widget.id,
          initialJudul: widget.initialJudul,
          initialPendahuluan: widget.initialPendahuluan,
          initialKonten: widget.initialKonten,
          initialImage: widget.initialImage,
        ),
      ),
    );
  }
}
