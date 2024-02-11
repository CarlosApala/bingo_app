import 'dart:convert';
import 'dart:math';
import 'dart:developer';
import 'package:uuid/uuid.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/boton_calculadora.dart';
import '../../../widgets/card_bingo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  HomeBloc()
      : super(HomeState(
            listCard: [],
            cantColum: 5,
            cantRow: 5,
            searchAutomatic: true,
            limitNumber: 75,
            numberComodin: 0)) {
    on<OnInit>((event, emit) async {
      SharedPreferences shared = await _prefs;
      List<String> lista = shared.getStringList('listCard') ?? [];
      String column = shared.getString('col') ?? '5';
      String filas = shared.getString('row') ?? '5';
      String limites = shared.getString('limit') ?? '75';
      String numeroComodin = shared.getString('nComodin') ?? '12';
      bool searAutomatica = shared.getBool('searAut') ?? false;

      List<String> listCard = [];
      List<CardBingo> newLista = [];

      print(lista[0]);
      for (var i = 0; i < lista.length; i++) {
        listCard.add(lista[i]);
        CardBingo bingo = CardBingo.fromJson(jsonDecode(lista[i]));
        newLista.add(bingo);
      }

      emit(state.copyToWith(
          listaCards: newLista,
          stados: [true],
          cantCo: int.parse(column),
          cantR: int.parse(filas),
          limiNum: int.parse(limites),
          numbCom: int.parse(numeroComodin),
          searchAut: searAutomatica));
    });
    on<InsertCardBingo>((event, emit) {
      List<CardBingo> lis = [...state.listCard!];

      if (kDebugMode) {
        print("valor de mi state cardbingo");
        print(state.listCard!.length);
      }

      Color color = getSoftRandomColor();

      //TODO: añadir los campos faltantes
      lis.add(CardBingo(
          numberComodin: event.numbComodin,
          limitNumber: event.limitNum,
          listBoton: [],
          column: event.column,
          row: event.filas,
          colorBackground: color,
          editar: false,
          numberCard: Uuid().v4()));

      lis[lis.length - 1].listBoton = lista(Uuid().v4());

      emit(state.copyToWith(listaCards: lis));
    });
    on<OnSaveConfiguration>(
      (event, emit) {
        emit(state.copyToWith(
            cantCo: event.column,
            cantR: event.filas,
            limiNum: event.limitNumber,
            searchAut: event.searchAut,
            numbCom: event.numcomdin) as HomeState);
      },
    );
    on<EditValores>(
      (event, emit) {
        List<CardBingo> listCards = [...state.listCard!];
        CardBingo cards;

        for (var i = 0; i < listCards.length; i++) {
          for (var j = 0; j < listCards[i].listBoton!.length; j++) {
            if (listCards[i].numberCard == event.numberCard) {
              listCards[i].listBoton![j].valornumerico = event.val[i];
            }
          }
        }

        /* for (var i = 0;
            i < listCards[event.numberCard].listBoton!.length;
            i++) {
          listCards[event.numberCard].listBoton![i].valornumerico =
              event.val[i];
        } */

        emit(state.copyToWith(listaCards: state.listCard));
      },
    );
    on<UpdateChargeBingo>(
      (event, emit) {
        emit(state.copyToWith(listaCards: event.listCa));
      },
    );
    on<EditCardBingo>((event, emit) {
      List<CardBingo> listCard = [...state.listCard!];

      for (var i = 0; i < listCard.length; i++) {
        for (var j = 0; j < listCard[i].listBoton!.length; j++) {
          /* listCard[i].listBoton![j].editar = event.edit; */
          if (listCard[i].listBoton![j].numeCard == event.numberCard) {
            listCard[i].listBoton![j].editar = event.edit;
          }
        }
      }
      /* listCard[event.numberCard].editar = event.edit; */

      emit(state.copyToWith(listaCards: listCard));
    });
    on<DeletePageView>((event, emit) async {
      SharedPreferences shared = await _prefs;
      List<CardBingo> newLista = [];

      List<CardBingo> list = [...state.listCard!];

      List<String> lista = shared.getStringList('listCard') ?? [];
      print(lista[0]);
      for (var i = 0; i < lista.length; i++) {
        CardBingo bingo = CardBingo.fromJson(jsonDecode(lista[i]));
        if (event.numerocard == bingo.numberCard) {
          continue;
        }
        newLista.add(bingo);
      }

      emit(state.copyToWith(listaCards: newLista));
    });
    on<OnPressEvent>((event, emit) {
      List<CardBingo> listCard = [...state.listCard!];

      listCard[event.numeroCard].listBoton![event.numeroButton].presionado =
          event.estado;

      emit(state.copyToWith(listaCards: listCard));
    });

    on<OnInsertButtonEvent>(
      (event, emit) {
        List<CardBingo> list = [...state.listCard!];

        list[event.numerCard].listBoton = event.lisbton;
        emit(state.copyToWith(listaCards: list));
      },
    );
    on<OnInsertListValoresNumeric>(
      (event, emit) {
        List<CardBingo> list = [...state.listCard!];

        for (var i = 0; i < list.length; i++) {
          for (var j = 0; j < list[i].listBoton!.length; j++) {
            if (list[i].listBoton![j].key == event.key) {
              list[i].listBoton![j].valornumerico = event.valorNumeric;
            }
          }
        }

        emit(state.copyToWith(listaCards: list));
      },
    );
    on<OnInsertListValoresPresionados>(
      (event, emit) {
        List<CardBingo> list = [...state.listCard!];

        if (state.searchAutomatic == true) {
          for (var i = 0; i < list.length; i++) {
            for (var j = 0; j < list[i].listBoton!.length; j++) {
              if (event.valNum == list[i].listBoton![j].valornumerico) {
                list[i].listBoton![j].presionado = event.presionado;
              }
              /* String valorNum=(list[i].listBoton![j].key == event.key)?list[i].listBoton![j].valornumerico!:"";
              if (list[i].listBoton![j].valornumerico == valorNum) {
                String valorNum = list[i].listBoton![j].valornumerico!;
                /*   list[i].listBoton![j].presionado = event.presionado; */
              } */
            }
          }
        }

        emit(state.copyToWith(listaCards: list));
      },
    );
    /* on<OnChangeCardEvent>(
      (event, emit) {
        List<CardBingo> list = [...state.listCard!];
        list[event.numeroCard].numberCard = event.numeroCard;
      },
    ); */
  }

  List<BotonCalculador> lista(String cantidad) {
    int multiplicar = state.cantColum! * state.cantRow!;
    List<BotonCalculador> listb = [];

    for (var i = 0; i < multiplicar; i++) {
      listb.add(BotonCalculador(
        presionado: false,
        activado: false,
        editar: false,
        numeCard: cantidad,
        /* numeroCard: cantidad, */
        comodin: state.numberComodin == i ? true : false,
        /* numeroButton: i, */
        icono: Image.asset('assets/bingo.png'),
      ));
    }
    return listb;
  }

  Color getSoftRandomColor() {
    Random random = Random();
    int min = 100; // Valor mínimo para los componentes de color
    int max = 200; // Valor máximo para los componentes de color
    int red = min + random.nextInt(max - min + 1);
    int green = min + random.nextInt(max - min + 1);
    int blue = min + random.nextInt(max - min + 1);
    return Color.fromARGB(255, red, green, blue);
  }
}

Future<void> clearSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  await sharedPreferences.remove('listCard');
  await sharedPreferences.remove('col');
  await sharedPreferences.remove('row');
  await sharedPreferences.remove('limit');
  await sharedPreferences.remove('nComodin');
  await sharedPreferences.remove('searAut');
}
