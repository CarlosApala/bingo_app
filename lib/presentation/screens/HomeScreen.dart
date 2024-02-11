import 'package:bingo_app/presentation/bloc/bloc/home_bloc.dart';
import 'package:bingo_app/widgets/card_bingo.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_radio_slider/flutter_radio_slider.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:particles_fly/particles_fly.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/boton_calculadora.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _limintNumber = TextEditingController();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(OnInit(
        cantColum: 5,
        cantRow: 5,
        limitNumber: 75,
        numberComodin: 12,
        searchAutomatic: true));
    super.initState();
    _limintNumber.text = '75';
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    final SharedPreferences prefs = await _prefs;

    print(prefs.getString('limit'));
    _currentSliderColumnValue = prefs.getDouble('column') ?? 5.0;
    _currentSliderRowValue = prefs.getDouble('filas') ?? 5.0;

    setState(() {});
  }

  bool imageCard = false;
  int selectState = 0;
  bool valueSwitch = false;

  bool esperar = false;
  bool? _conect = false;
  double _currentSliderRowValue = 1;
  double _currentSliderColumnValue = 1;
  List<Widget> cartas = [];

  List<Widget> fruits = <Widget>[Text('Automatica'), Text('Manual')];
  final List<bool> _selectedFruits = <bool>[true, false];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state is HomeState) {
        final size = MediaQuery.of(context).size;
        int multiCartas =
            _currentSliderRowValue.toInt() * _currentSliderRowValue.toInt();
        cartas.clear();
        for (var i = 0; i < multiCartas; i++) {
          cartas.add(FormCard(
            index: i,
          ));
        }
        _conect = state.listCard == null ? true : false;
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
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: _limintNumber,
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

                  /* este codigo solo debe ser desactivado si la logica de esta completado */
                  Text(
                    'Seleccione el tipo de Busqueda:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  ToggleButtons(
                    direction: Axis.horizontal,
                    onPressed: (int index) {
                      setState(() {
                        // The button that is tapped is set to true, and the others to false.
                        for (int i = 0; i < _selectedFruits.length; i++) {
                          _selectedFruits[i] = i == index;
                        }
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    selectedBorderColor: Colors.green[700],
                    selectedColor: Colors.white,
                    fillColor: Colors.green[200],
                    color: Colors.red[400],
                    constraints: const BoxConstraints(
                      minHeight: 40.0,
                      minWidth: 80.0,
                    ),
                    isSelected: _selectedFruits,
                    children: fruits,
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
                      onPressed: () {
                        BlocProvider.of<HomeBloc>(context).add(
                            OnSaveConfiguration(
                                column: _currentSliderRowValue.toInt(),
                                filas: _currentSliderRowValue.toInt(),
                                searchAut: _selectedFruits[0],
                                limitNumber:
                                    int.parse(_limintNumber.value.text),
                                numcomdin: selectState));
                        Navigator.pop(context);
                      },
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
                            // guardar los cambios que se estaban realizando en una tarjeta, antes de crear una nueva

                            for (var element in state.listCard!) {
                              if (element.editar!) {
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) => AlertDialog(
                                          title: Text("Edicion"),
                                          content:
                                              Text("Se edito correctamente"),
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
                            //-------------------------------------fin de guardar-------

                            Future.delayed(Duration(milliseconds: 500))
                                .then((value) {
                              esperar = false;
                              setState(() {});
                            });

                            BlocProvider.of<HomeBloc>(context).add(
                                InsertCardBingo(
                                    column: state.cantColum!,
                                    filas: state.cantRow!,
                                    limitNum: state.limitNumber!,
                                    numbComodin: state.numberComodin!));
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
            body: PageBingo());
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }

  Widget FormCard({required index}) {
    return GestureDetector(
      onTap: () {
        selectState = index;
        imageCard = !imageCard;
        setState(() {});
      },
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: selectState == index
                ? Color.fromARGB(255, 32, 199, 10)
                : Colors.purple,
            borderRadius: BorderRadius.circular(20)),
        child: selectState == index
            ? Center(
                child: Text('Free',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 2, 28, 100))),
              )
            : null,
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
                  for (var element in listBingo) {
                    if (element.editar!) {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => AlertDialog(
                                title: Text("Edicion"),
                                content: Text("Se edito correctamente"),
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
