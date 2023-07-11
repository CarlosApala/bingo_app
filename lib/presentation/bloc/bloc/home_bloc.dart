import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../widgets/boton_calculadora.dart';
import '../../../widgets/card_bingo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState(listCard: [], estados: [])) {
    on<InsertCardBingo>((event, emit) {
      List<CardBingo> lis = [...state.listCard!];

      List<bool> esta = [...state.estados!];

      if (kDebugMode) {
        print("valor de mi state cardbingo");
        print(state.listCard!.length);
      }
      //lis[1].listPresionado[1] = true;
      Color color = getSoftRandomColor();
      lis.add(CardBingo(
        colorBackground: color,
        editar: false,
        numberCard: state.listCard!.length,
      ));
      lis[lis.length - 1].listBoton = lista(lis.length - 1);

      esta.add(false);

      emit(state.copyToWith(listaCards: lis, stados: esta));
    });
    on<EditCardBingo>((event, emit) {
      List<bool> lis = [...state.estados!];
      List<CardBingo> listCard = [...state.listCard!];

      listCard[event.numberCard].editar = event.edit;
      lis[event.numberCard] = event.edit;
      lis.forEach(
        (element) {
          print(element);
        },
      );
      emit(state.copyToWith(stados: lis, listaCards: listCard));
    });
    on<DeletePageView>((event, emit) {
      int volve = 0;
      List<CardBingo> list = [...state.listCard!];
      List<bool> esta = [...state.estados!];
      esta.remove(esta[event.numerocard]);
      list.remove(list[event.numerocard]);
      for (var element in list) {
        element.numberCard = volve++;
      }
      emit(state.copyToWith(listaCards: list));
    });
    on<OnPressEvent>((event, emit) {
      List<CardBingo> listCard = [...state.listCard!];

      listCard[event.numeroCard].listBoton[event.numeroButton].presionado =
          event.estado;
      /* listCard[event.numeroCard].listPresionado; */

      emit(state.copyToWith(listaCards: listCard));
    });
    /* on<OnValueEvent>(
      (event, emit) {
        List<CardBingo> list = [...state.listCard!];

        list[event.numerCard].listvaloresNumericos[event.numeroButton] =
            event.valorNumerico;

        emit(state.copyToWith(listaCards: list));
      },
    ); */
    on<OnInsertButtonEvent>(
      (event, emit) {
        List<CardBingo> list = [...state.listCard!];

        list[event.numerCard].listBoton = event.lisbton;
        emit(state.copyToWith(listaCards: list));
      },
    );
    on<OnEvent>(
      (event, emit) {
        emit(state.copyToWith());
      },
    );
    on<OnInsertListValoresNumeric>(
      (event, emit) {
        List<CardBingo> list = [...state.listCard!];

        list[event.numerCard].listBoton[event.numeroButton].valornumerico =
            event.valorNumeric;
        emit(state.copyToWith(listaCards: list));
      },
    );
    on<OnInsertListValoresPresionados>(
      (event, emit) {
        List<CardBingo> list = [...state.listCard!];
        list[event.numerCard].listBoton[event.numerButton].presionado =
            event.presionado;
        emit(state.copyToWith(listaCards: list));
      },
    );
    on<OnChangeCardEvent>(
      (event, emit) {
        List<CardBingo> list = [...state.listCard!];
        list[event.numeroCard].numberCard = event.numeroCard;
      },
    );
  }

  List<BotonCalculador> lista(int cantidad) {
    List<BotonCalculador> listb = [];
    for (var i = 0; i < 27; i++) {
      listb.add(BotonCalculador(
        presionado: false,
        activado: false,
        editar: false,
        numeroCard: cantidad,
        numeroButton: i,
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
