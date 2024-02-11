import 'package:bingo_app/presentation/bloc/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BotonCalculador extends StatefulWidget {
  Map<String, dynamic> toMap() {
    return {
      "activado": activado,
      "comodin": comodin,
      "editar": editar,
      "numeCard": numeCard,
      "presionado": presionado,
      "valornumerico": valornumerico,
    };
  }

  factory BotonCalculador.fromJson(Map<String, dynamic> json) =>
      BotonCalculador(
        /* presionado: json["presionado"],
        valornumerico: json["valornumerico"], */
        activado: json['activado'],
        comodin: json['comodin'],
        editar: json['editar'],
        numeCard: json['numeCard'],
        presionado: json['presionado'],
        valornumerico: json['valornumerico'],
      );

  /* final int? numeroButton; */
  String? valornumerico;
  final bool? activado;
  final Image? icono;
  bool presionado;
  bool? comodin;
  String? numeCard;

  bool? editar;
  Key? key;

  final TextStyle? style;
  BotonCalculador(
      {this.icono,
      this.style,
      this.presionado = false,
      this.activado,
      this.editar,
      this.comodin,
      this.numeCard,
      /* required this.numeroButton, */
      this.valornumerico = ""}) {
    key = GlobalKey();
  }

  @override
  State<BotonCalculador> createState() => _BotonCalculadorState();
}

class _BotonCalculadorState extends State<BotonCalculador> {
  Color _color1 = Color.fromRGBO(46, 47, 56, 1);

  Color _color2 = Color.fromRGBO(57, 214, 154, 1);

  bool iniciarValores = true;

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
        if (iniciarValores) {
          BlocProvider.of<HomeBloc>(context).add(OnInsertListValoresNumeric(
              key: widget.key!,
              numerCard: widget.numeCard!,
              valorNumeric: widget.valornumerico!));
          iniciarValores = false;
        }

        return Container(
            key: GlobalKey(),
            margin: EdgeInsets.all(5),
            child: ElevatedButton(
                style: ButtonStyle(
                    textStyle: MaterialStateTextStyle.resolveWith(
                        (states) => TextStyle(fontSize: 20)),
                    shape: MaterialStateProperty.resolveWith((states) =>
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) => _color),
                    padding: MaterialStateProperty.resolveWith(
                        (states) => const EdgeInsets.all(10))),
                onPressed: widget.activado == false
                    ? () {
                        print(widget.valornumerico);
                        if (widget.presionado == true) {
                          widget.presionado = false;
                          _color = _color1;
                          BlocProvider.of<HomeBloc>(context)
                              .add(OnInsertListValoresPresionados(
                            key: widget.key!,
                            valNum: widget.valornumerico!,
                            presionado: false,
                          ));
                          return;
                        }
                        if (widget.valornumerico!.isNotEmpty) {
                          widget.presionado = true;
                          BlocProvider.of<HomeBloc>(context)
                              .add(OnInsertListValoresPresionados(
                            key: widget.key!,
                            valNum: widget.valornumerico!,
                            presionado: true,
                          ));

                          if (widget.presionado == true) {
                            _color = _color2;
                          } else {
                            _color = _color1;
                          }
                        }
                      }
                    : null,
                child: widget.comodin!
                    ? Text('Free',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(255, 224, 194, 103)))
                    : widget.editar == false
                        ? widget.valornumerico != ""
                            ? Text(
                                widget.valornumerico!,
                                style: widget.style ??
                                    const TextStyle(fontSize: 30),
                              )
                            : widget.icono
                        : TextField(
                            controller: _controller,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              /* BlocProvider.of<HomeBloc>(context).add(OnEvent()); */
                              BlocProvider.of<HomeBloc>(context).add(
                                  OnInsertListValoresNumeric(
                                      key: widget.key!,
                                      valorNumeric: value,
                                      numerCard: widget.numeCard!));
                            },
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 30),
                                labelStyle: TextStyle(
                                    color: Colors.white, fontSize: 30)),
                          )));
      },
    );
  }
}
