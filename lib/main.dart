import 'package:currency_converter/pages/converter_page.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;//pacote para fazer recsições
import 'dart:async';
import 'dart:convert';


const request = "https://api.hgbrasil.com/finance";//link da api

void main ()async{


  runApp(const MyApp());


}

Future<Map> getData() async{//função assincrona que servira para esperar a recsção
  http.Response response = await http.get(Uri.parse(request));//pegando os dados da api(e esperando com await)e convertendo de string para Uri

  return json.decode(response.body);//transformando a String que vem da API em mapa;

}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,//tirando o aviso de modo debug
      home: ConverterPage(),
      theme: ThemeData(
          hintColor: Colors.amber,
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            hintStyle: TextStyle(color: Colors.amber),
          )),
    );

  }
}
