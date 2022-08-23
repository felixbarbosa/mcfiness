import 'package:flutter/material.dart';
import 'package:mcfitness/pages/anamnese/anamnese_nova_anamnese.dart';
import 'package:mcfitness/pages/avaliacaoFisica/avaliacaoFisica_nova_avaliacao.dart';
import 'package:mcfitness/pages/home/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      home: Home_Page(
        
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark
      ),
    )
  );
}
