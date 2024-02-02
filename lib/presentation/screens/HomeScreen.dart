import 'package:bingo_app/presentation/bloc/bloc/home_bloc.dart';
import 'package:bingo_app/widgets/card_bingo.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_radio_slider/flutter_radio_slider.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:particles_fly/particles_fly.dart';

import '../../widgets/boton_calculadora.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool esperar = false;
  bool? _conect = false;
  double _currentSliderRowValue = 1;
  double _currentSliderColumnValue = 1;
  List<Widget> cartas = [];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    int multiCartas =
        _currentSliderColumnValue.toInt() * _currentSliderRowValue.toInt();

    cartas.clear();
    for (var i = 0; i < multiCartas; i++) {
      cartas.add(FormCard());
    }

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        _conect = state.listCard!.length == 0 ? true : false;

        return Scaffold(
            drawer: SafeArea(
              child: Drawer(
                  child: Column(
                children: [
                  Text(
                    'Configuraciones',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  Column(
                    children: [
                      Text(
                        'Seleccione...',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Cant. filas',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Slider(
                                    value: _currentSliderRowValue,
                                    max: 6,
                                    min: 1,
                                    divisions: 5,
                                    label: _currentSliderRowValue
                                        .round()
                                        .toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        _currentSliderRowValue = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Cant. Columnas',
                                    style: TextStyle(
                                        fontSize: 20,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Slider(
                                    value: _currentSliderColumnValue,
                                    max: 6,
                                    min: 1,
                                    divisions: 5,
                                    label: _currentSliderColumnValue
                                        .round()
                                        .toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        _currentSliderColumnValue = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          helperText: 'cant. maxima de numero en el bingo',
                          label: Text(
                            'limite de numeros',
                            style: TextStyle(fontSize: 20),
                          ),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Seleccione la casilla que tendra un comidin'),
                  Expanded(
                      child: GridView.count(
                    crossAxisCount: _currentSliderRowValue.toInt(),
                    padding: EdgeInsets.all(2),
                    childAspectRatio: 1,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    children: [...cartas],
                  )),
                  ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Aceptar',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 181, 252, 50),
                            fontWeight: FontWeight.bold),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 42, 156, 80)))),
                ],
              )),
            ),
            appBar: AppBar(
              title: Text("Bingo", style: TextStyle(color: Colors.white)),
              centerTitle: true,
              backgroundColor: Colors.indigo,
              actions: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.indigo.shade200,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: esperar == false
                        ? () async {
                            for (var element in state.listCard!) {
                              if (element.editar) {
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) => AlertDialog(
                                          title: Text("Edicion"),
                                          content: Text(
                                              "la tarjeta ${element.numberCard + 1}, se edito correctamente"),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('ok'))
                                          ],
                                        ));

                                BlocProvider.of<HomeBloc>(context).add(
                                    EditCardBingo(
                                        edit: false,
                                        numberCard: element.numberCard));
                                return;
                              }
                            }
                            Future.delayed(Duration(milliseconds: 500))
                                .then((value) {
                              esperar = false;
                              setState(() {});
                            });

                            BlocProvider.of<HomeBloc>(context)
                                .add(InsertCardBingo());
                            esperar = true;
                          }
                        : null,
                    child: Icon(Icons.add),
                    style: ButtonStyle(
                        elevation:
                            MaterialStateProperty.resolveWith((states) => 0),
                        iconColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.indigo)),
                  ),
                )
              ],
            ),
            body: Stack(children: [
              ParticlesFly(
                height: size.height,
                width: size.width,
                speedOfParticles: !_conect! ? 1 : 2,
                numberOfParticles: 50,
                maxParticleSize: 15,
                onTapAnimation: true,
              ),
              Container(
                  width: !_conect! ? double.infinity : 0,
                  height: !_conect! ? double.infinity : 0,
                  child: PageBingo())
            ]));
      },
    );
  }
}

class FormCard extends StatefulWidget {
  FormCard({
    super.key,
  });

  @override
  State<FormCard> createState() => _FormCardState();
}

class _FormCardState extends State<FormCard> {
  bool imageCard = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        imageCard = !imageCard;
        setState(() {});
      },
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: Colors.purple, borderRadius: BorderRadius.circular(20)),
        child: imageCard ? Image.asset('assets/bingo.png') : null,
      ),
    );
  }
}

class PageBingo extends StatefulWidget {
  PageBingo({super.key});

  @override
  State<PageBingo> createState() => _PageBingoState();
}

class _PageBingoState extends State<PageBingo> {
  final PageController _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  bool? retroceder = false;
  int? _valorPage;
  List<CardBingo> listBingo = [];
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final size = MediaQuery.of(context).size.width;

        if (state.listCard!.length > listBingo.length) {
          _pageController.jumpToPage(state.listCard!.length);
        }
        listBingo = [...state.listCard!];

        return Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (value) {
                  print(value);

                  for (var element in listBingo) {
                    if (element.editar) {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => AlertDialog(
                                title: Text("Edicion"),
                                content: Text(
                                    "la tarjeta ${element.numberCard + 1}, se edito correctamente"),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('ok'))
                                ],
                              ));

                      BlocProvider.of<HomeBloc>(context).add(EditCardBingo(
                          edit: false, numberCard: element.numberCard));
                      return;
                    }
                  }
                  _currentPageNotifier.value = value;
                },
                children: <CardBingo>[...state.listCard!],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CirclePageIndicator(
                itemCount: state.listCard!.length,
                currentPageNotifier: _currentPageNotifier,
              ),
            ),
          ],
        );
      },
    );
  }
}
