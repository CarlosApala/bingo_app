part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class InsertCardBingo extends HomeEvent {
  int filas;
  int column;
  int limitNum;
  int numbComodin;

  InsertCardBingo(
      {required this.column,
      required this.filas,
      required this.limitNum,
      required this.numbComodin});
}

class OnInit extends HomeEvent {
  int? cantRow;
  int? cantColum;
  int? limitNumber = 90;
  int? numberComodin;
  bool? searchAutomatic;
  OnInit(
      {required this.cantColum,
      required this.cantRow,
      required this.limitNumber,
      required this.numberComodin,
      required this.searchAutomatic});
}

class OnSaveConfiguration extends HomeEvent {
  int filas;
  int column;
  int limitNumber;
  int numcomdin;
  bool searchAut;
  OnSaveConfiguration(
      {required this.column,
      required this.filas,
      required this.limitNumber,
      required this.numcomdin,
      required this.searchAut});
}

class UpdateChargeBingo extends HomeEvent {
  List<CardBingo> listCa;
  UpdateChargeBingo({required this.listCa});
}

class EditCardBingo extends HomeEvent {
  String numberCard;
  bool edit;
  EditCardBingo({required this.edit, required this.numberCard});
}

class DeletePageView extends HomeEvent {
  String numerocard;
  DeletePageView({required this.numerocard});
}

class EditValores extends HomeEvent {
  List<String> val;
  String numberCard;
  EditValores({required this.val, required this.numberCard});
}

class OnPressEvent extends HomeEvent {
  int numeroCard;
  int numeroButton;
  bool estado;

  OnPressEvent({
    required this.numeroCard,
    required this.estado,
    required this.numeroButton,
  });
}

class OnValueEvent extends HomeEvent {
  String valorNumerico;
  int numerCard;
  int numeroButton;
  OnValueEvent(
      {required this.valorNumerico,
      required this.numerCard,
      required this.numeroButton});
}

class OnInsertListValoresNumeric extends HomeEvent {
  String numerCard;
  /* int numeroButton; */
  Key key;
  String valorNumeric;
  OnInsertListValoresNumeric(
      {required this.valorNumeric,
      /* required this.numeroButton, */
      required this.key,
      required this.numerCard});
}

class OnInsertListValoresPresionados extends HomeEvent {
  Key key;
  bool presionado;
  String valNum;
  OnInsertListValoresPresionados(
      {required this.presionado, required this.key, required this.valNum});
}

class OnInsertButtonEvent extends HomeEvent {
  List<BotonCalculador> lisbton;
  int numerCard;
  OnInsertButtonEvent({required this.lisbton, required this.numerCard});
}

/* class OnChangeCardEvent extends HomeEvent {
  String numeroCard;
  OnChangeCardEvent({required this.numeroCard});
} */
