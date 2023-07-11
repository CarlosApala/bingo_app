import 'package:bingo_app/presentation/bloc/bloc/home_bloc.dart';
import 'package:bingo_app/widgets/card_bingo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        _conect = state.listCard!.length == 0 ? true : false;

        return Scaffold(
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
