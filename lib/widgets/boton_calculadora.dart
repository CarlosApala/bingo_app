import 'package:bingo_app/presentation/bloc/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BotonCalculador extends StatefulWidget {
  final int? numeroCard;
  final int? numeroButton;
  String? valornumerico;
  final bool? activado;
  final Image? icono;
  bool presionado;

  bool? editar;

  final TextStyle? style;
  BotonCalculador(
      {Key? key,
      this.numeroCard,
      this.icono,
      this.style,
      this.presionado = false,
      required this.activado,
      required this.editar,
      required this.numeroButton,
      this.valornumerico = ""})
      : super(key: key);

  @override
  State<BotonCalculador> createState() => _BotonCalculadorState();
}

class _BotonCalculadorState extends State<BotonCalculador> {
  Color _color1 = Color.fromRGBO(46, 47, 56, 1);

  Color _color2 = Color.fromRGBO(57, 214, 154, 1);

  late Color _color;

  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _color = _color1;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    _controller.text = widget.valornumerico!;
    if (widget.presionado == true) {
      _color = _color2;
    } else {
      _color = _color1;
    }

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Container(
            margin: EdgeInsets.all(5),
            child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.resolveWith((states) =>
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) => _color),
                    padding: MaterialStateProperty.resolveWith(
                        (states) => const EdgeInsets.all(10))),
                onPressed: widget.activado == false
                    ? () {
                        if (widget.presionado == true) {
                          widget.presionado = false;
                          _color = _color1;
                          BlocProvider.of<HomeBloc>(context).add(
                              OnInsertListValoresPresionados(
                                  numerCard: widget.numeroCard!,
                                  presionado: false,
                                  numerButton: widget.numeroButton!));
                          return;
                        }
                        if (widget.valornumerico!.isNotEmpty) {
                          widget.presionado = true;
                          print("imprimiendo valor de currente");
                          print(state.listCard![widget.numeroCard!]
                              .listBoton[widget.numeroButton!].numeroCard!);
                          BlocProvider.of<HomeBloc>(context).add(
                              OnInsertListValoresPresionados(
                                  presionado: true,
                                  numerCard: widget.numeroCard!,
                                  numerButton: widget.numeroButton!));

                          if (widget.presionado == true) {
                            _color = _color2;
                          } else {
                            _color = _color1;
                          }
                        }
                      }
                    : null,
                child: widget.editar == false
                    ? widget.valornumerico != ""
                        ? Text(
                            widget.valornumerico!,
                            style:
                                widget.style ?? const TextStyle(fontSize: 30),
                          )
                        : widget.icono
                    : TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          widget.valornumerico = value;
                          /* BlocProvider.of<HomeBloc>(context).add(OnEvent()); */
                          BlocProvider.of<HomeBloc>(context).add(
                              OnInsertListValoresNumeric(
                                  numerCard: widget.numeroCard!,
                                  numeroButton: widget.numeroButton!,
                                  valorNumeric: value));
                        },
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                        decoration: InputDecoration(
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 30),
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: 30)),
                      )));
      },
    );
  }
}
