import 'dart:convert';
import 'dart:math';

import 'package:bingo_app/widgets/boton_calculadora.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/bloc/bloc/home_bloc.dart';

List<CardBingo> listCardFromJson(String str) =>
    List<CardBingo>.from(json.decode(str).map((x) => CardBingo.fromJson(x)));
String listCardToJson(List<CardBingo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

// Funciones auxiliares para la serialización del color
Color jsonToColor(Map<String, dynamic> json) {
  return Color.fromARGB(
      json['alpha'], json['red'], json['green'], json['blue']);
}

class CardBingo extends StatefulWidget {
  Map<String, dynamic> toMap() {
    List<BotonCalculador> list = [...listBoton!];
    List<Map<String, dynamic>> listMap = [];

    for (var i = 0; i < list.length; i++) {
      listMap.add(listBoton![i].toMap());
    }

    return {
      'numberCard': numberCard,
      'listButton': listMap,
      'colorBackground': colorToJson(colorBackground!),
      'column': column,
      'limitNumber': limitNumber,
      'numberComodin': numberComodin,
      'row': row,
      'editar': editar,
    };
  }

  factory CardBingo.fromJson(Map<String, dynamic> json) => CardBingo(
        column: json['column'],
        limitNumber: json['limitNumber'],
        numberComodin: json['numberComodin'],
        row: json['row'],
        editar: json['editar'],
        colorBackground: jsonToColor(json['colorBackground']),
        numberCard: json["numberCard"],
        listBoton: List<BotonCalculador>.from(
            json["listButton"].map((x) => BotonCalculador.fromJson(x))),
      );

  Map<String, dynamic> colorToJson(Color color) {
    return {
      'red': color.red,
      'green': color.green,
      'blue': color.blue,
      'alpha': color.alpha,
    };
  }

  CardBingo(
      {super.key,
      this.editar = false,
      required this.numberCard,
      required this.listBoton,
      required this.limitNumber,
      required this.column,
      required this.row,
      required this.numberComodin,
      required this.colorBackground});
  Color? colorBackground;
  int? limitNumber;
  String numberCard;
  int? column;
  int? row;

  int? numberComodin;
  List<BotonCalculador>? listBoton = [];

  bool? editar;

  @override
  State<CardBingo> createState() => _CardBingoState();
}

class _CardBingoState extends State<CardBingo> {
  List<String> listNumberCard = [];
  bool generateLista = false;
  String idCard = "0";
  /* bool estadoLocal = false; */
  bool iniList = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    idCard = generateUniqueNumber();
    widget.colorBackground.toString();
  }

  List<BotonCalculador> list = [];
  @override
  Widget build(BuildContext context) {
    if (iniList) {
      listNumberCard = generarNumerosAleatorios(
          widget.limitNumber!, widget.column! * widget.row!);
      iniList = false;
      list = [...widget.listBoton!];
      for (var i = 0; i < list.length; i++) {
        list[i].editar = false;
        list[i].valornumerico = listNumberCard[i].toString();
      }
    }

    if (widget.editar == true) {
      for (var i = 0; i < widget.listBoton!.length; i++) {
        bool press = widget.listBoton![i].presionado;
        String valor = widget.listBoton![i].valornumerico!;
        list.replaceRange(i, i + 1, [
          BotonCalculador(
            presionado: press,
            activado: false,
            editar: true,
            numeCard: widget.numberCard,
            /* numeroButton: numeroButton, */
            valornumerico: listNumberCard.isNotEmpty
                ? listNumberCard[i].toString()
                : valor,
            comodin: widget.numberComodin == i,
          )
        ]);
      }
    } else {
      list = [...widget.listBoton!];
      for (var i = 0; i < list.length; i++) {
        list[i].editar = false;
      }
    }
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      /* print('layout ${widget.listCard![widget.numberCard].numberCard} '); */
      print(widget.numberCard);

      return Container(
        margin: EdgeInsets.only(top: 20, bottom: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: widget.colorBackground),
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /* Text(
                      'Codigo: ${idCard}',
                      style: TextStyle(color: Colors.amber),
                    ), */
                    Text(
                      "Codigo N°:  ${widget.numberCard.substring(0, 4)}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                )),
            Expanded(
              flex: 6,
              child: GridView.count(
                  crossAxisCount: widget.row!,
                  childAspectRatio: 1,
                  children: [...list]),
            ),
            Visibility(
                /* visible: widget.listBoton![widget.numberCard].editar!, */
                visible: widget.editar!,
                /* state.listCard![widget.numberCard].editar!, */
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 189, 248, 162))),
                    onPressed: () {
                      listNumberCard = generarNumerosAleatorios(
                          widget.limitNumber!, widget.column! * widget.row!);

                      BlocProvider.of<HomeBloc>(context).add(EditValores(
                          val: [...listNumberCard],
                          numberCard: widget.numberCard));
                      setState(() {});
                    },
                    child: Text('Elegir numeros Random'))),
            SizedBox(
              child: Row(
                children: [
                  /* Expanded(
                      child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.blue)),
                    onPressed: () {
                      if (!widget.editar!) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Atención!'),
                              content: const Text(
                                  'Intentar editar, es hacer trampa 😒, y su codigo de tarjeta cambiará por seguridad'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      BlocProvider.of<HomeBloc>(context).add(
                                          EditCardBingo(
                                              edit: true,
                                              numberCard: widget.numberCard));
                                      setState(() {});

                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Continuar')),
                                TextButton(
                                  onPressed: () {
                                    // Cerrar el cuadro de diálogo
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cerrar'),
                                ),
                              ],
                            );
                          },
                        );

                        idCard = generateUniqueNumber();
                      } else {
                        print(listNumberCard);
                        BlocProvider.of<HomeBloc>(context).add(EditCardBingo(
                            edit: widget.editar!,
                            /* !state
                                        .listCard![widget.numberCard].editar!, */
                            numberCard: widget.numberCard));
                      }
                    },
                    child: Text(widget.editar! ? 'editar' : "aceptar",
                        style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 110, 63, 63))),
                  )), */
                  Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.red)),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  actionsAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  title: const Text('Cuidado!'),
                                  content: const Text(
                                      'esta seguro de borrar la tarjeta'),
                                  actions: [
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty
                                                .resolveWith((states) =>
                                                    EdgeInsets.symmetric(
                                                        horizontal: 60,
                                                        vertical: 10)),
                                            backgroundColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) => Colors.green)),
                                        onPressed: () {
                                          BlocProvider.of<HomeBloc>(context)
                                              .add(DeletePageView(
                                                  numerocard:
                                                      widget.numberCard));
                                          //widget.numberCard = 0;
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Ok',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.red)),
                                      onPressed: () {
                                        // Cerrar el cuadro de diálogo
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('No',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text(
                            'eliminar',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )))
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  List<String> generarNumerosAleatorios(int rango, int cantidad) {
    if (cantidad > rango) {
      throw ArgumentError(
          "La cantidad de números debe ser menor o igual al rango");
    }

    List<int> numerosDisponibles = List.generate(rango, (index) => index + 1);
    List<String> numerosAleatorios = [];

    Random random = Random();

    for (int i = 0; i < cantidad; i++) {
      // Obtén un índice aleatorio de los números disponibles
      int indiceAleatorio = random.nextInt(numerosDisponibles.length);

      // Agrega el número correspondiente al índice aleatorio a la lista de números aleatorios
      numerosAleatorios.add(numerosDisponibles[indiceAleatorio].toString());

      // Elimina el número utilizado de la lista de números disponibles
      numerosDisponibles.removeAt(indiceAleatorio);
    }

    return numerosAleatorios;
  }

  String generateUniqueNumber() {
    Random random = Random();
    int uniqueValue =
        random.nextInt(9999); // Rango personalizable según tus necesidades
    return uniqueValue.toString().padLeft(4,
        '0'); // Asegura 6 dígitos llenando con ceros a la izquierda si es necesario
  }
}
