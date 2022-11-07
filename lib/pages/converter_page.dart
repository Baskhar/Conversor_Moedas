import 'package:currency_converter/main.dart';
import 'package:flutter/material.dart';

class ConverterPage extends StatefulWidget {
  const ConverterPage({Key? key}) : super(key: key);

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  late double dolar;
  late double euro;
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text) {
    //função para verificar quando o real mudar
    double real = double.parse(text);//convertendo o texto pra double
    dolarController.text = (real/dolar).toStringAsFixed(2);//pegando o valor do text field e fazendo a operação com o dolar
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    //função para verificar quando o dolar mudar
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar *this.dolar/euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    //função para verificar quando o euro mudar
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro *this.euro/dolar).toStringAsFixed(2);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extrutura da tela
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          //ações da minha barra
          IconButton(
            //botão refrash
            onPressed: _resetFields, //função vazia
            icon: const Icon(Icons.refresh),
            color: Colors.black,
          ),
        ],
        title: const Text(
          '\$ Conversor \$',
          style: TextStyle(
            color: Colors.black,
          ),
        ), //texto
        centerTitle: true, //centralizar
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
          //corpo, futuro, ele vai esperar a recsição para construir a tela, enquanto não acontece ele manda uma mensagem de espera
          future: getData(), //recsição
          builder: (context, snapshot) {
            //construtor que irá tratar a tela(em todos os casos)
            //snapshot(uma cópia momentanea dos dados da api)
            switch (snapshot.connectionState) {
              //verifica o estado da conexão
              //caso as dados ainda não constam, ele retorna o Text
              case ConnectionState.none: //se não estiver conectado
              case ConnectionState.waiting: //ou esperando
                return const Center(
                  //retorna o texto
                  child: Text(
                    "Carregando Dados...",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center, //centralizando o texto
                  ),
                );
              default: //caso contrário(erro)
                if (snapshot.hasError) {
                  //se ele retornar erro
                  return const Center(
                    child: Text(
                      "Erro ao Carregar os Dados :(",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0,
                      ),
                      textAlign: TextAlign.center, //centralizando o texto
                    ),
                  );
                } else {
                  //se n tiver erro
                  //armazenando o mapa nas variaveis
                  dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      //serve para rolar a tela ao abrir o teclado
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        //alargando os elementos da coluna(centralizando)
                        //coluna
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            size: 150,
                            color: Colors.amber,
                          ),
                          //Campo de Texto 1(Reais)
                          const SizedBox(height: 20), //separando
                          buildTextField(
                              "Reais", "R\$: ", realController, _realChanged),
                          const SizedBox(height: 12),
                          //Campo de Texto 2(Dólar)
                          buildTextField("Dólares", "US\$: ", dolarController,
                              _dolarChanged),
                          const SizedBox(height: 12),

                          //Campo de Texto 3(EURO)
                          buildTextField(
                              "Euros", "€: ", euroController, _euroChanged),
                        ],
                      ),
                    ),
                  );
                }
            }
          }),
    );
  }

  Widget buildTextField(String label, String prefix, TextEditingController c,
      Function(String) f) {
    //função de criação do textField
    return //Campo de Texto 3(EURO)
        TextField(
      //campo de texto
      onChanged: f,
      controller: c,
      //controlador passado por parâmetro
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        //personalizando o campo de texto
        border: const OutlineInputBorder(//borda

            ),
        labelText: label,
        prefixText: prefix, //prefixo texto(no text field)
        labelStyle: const TextStyle(
          color: Colors.amber,
        ),
      ),
      style: const TextStyle(
        //estilo da text field
        color: Colors.amber,
        fontSize: 25.0,
      ),
    );
  }
  void _resetFields() {
    //função para o botão reset
    realController.text = "";
    dolarController.text = "";
   euroController.text= "";
  }
}
