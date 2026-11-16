import 'package:flutter/material.dart';
import '../../data/sample/sample_data.dart';
import 'subject_detail_screen.dart';
class SubjectsScreen extends StatelessWidget { const SubjectsScreen({super.key}); @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Toutes les matières')),body:ListView(padding:const EdgeInsets.all(16),children:demoSubjects.map((s)=>Card(child:ListTile(leading:const Icon(Icons.menu_book,color:Color(0xFF006A4E)),title:Text(s.name),subtitle:Text('Classe : ${s.level.label}'),trailing:const Icon(Icons.arrow_forward_ios,size:16),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>SubjectDetailScreen(subject:s)))))).toList()); }
