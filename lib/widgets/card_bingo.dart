import 'package:bingo_app/widgets/boton_calculadora.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/bloc/bloc/home_bloc.dart';

class CardBingo extends StatefulWidget {
  CardBingo(
      {super.key,
      required this.editar,
      required this.numberCard,
      required this.colorBackground});
  final Color colorBackground;
  int numberCard;

  List<BotonCalculador> listBoton = [];

  bool editar;

  @override
  State<CardBingo> createState() => _CardBingoState();
}

class _CardBingoState extends State<CardBingo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<BotonCalculador> list = [];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (widget.editar == true) {
          for (var i = 0; i < widget.listBoton.length; i++) {
            bool press = widget.listBoton[i].presionado;
            int numCard = widget.numberCard;
            String valor = widget.listBoton[i].valornumerico!;
            int numeroButton = widget.listBoton[i].numeroButton!;
            list.replaceRange(i, i + 1, [
              BotonCalculador(
                presionado: press,
                activado: false,
                editar: true,
                numeroCard: numCard,
                numeroButton: numeroButton,
                valornumerico: valor,
              )
            ]);
          }
        } else {
          list = [...widget.listBoton];
          for (var i = 0; i < list.length; i++) {
            list[i].editar = false;
          }
        }
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          final size = constraints;

          print(size.maxHeight);
          return Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: widget.colorBackground),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: GridView.count(
                        crossAxisCount: 3,
                        childAspectRatio: 1.8,
                        children: [...list]),
                  ),
                ),
                SizedBox(
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blue)),
                        onPressed: () {
                          print(widget.numberCard);
                          BlocProvider.of<HomeBloc>(context).add(EditCardBingo(
                              edit: !state.listCard![widget.numberCard].editar,
                              numberCard: widget.numberCard));
                          setState(() {});
                        },
                        child: Text(
                            !state.estados![widget.numberCard]
                                ? 'editar'
                                : "aceptar",
                            style: TextStyle(
                                fontSize: 20,
                                color: const Color.fromARGB(255, 110, 63, 63))),
                      )),
                      Expanded(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.red)),
                              onPressed: () {
                                BlocProvider.of<HomeBloc>(context).add(
                                    DeletePageView(
                                        numerocard: widget.numberCard));
                              },
                              child: Text(
                                'eliminar',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )))
                    ],
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }
}
