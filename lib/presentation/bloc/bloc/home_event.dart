part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class InsertCardBingo extends HomeEvent {
  InsertCardBingo();
}

class OnEvent extends HomeEvent {}

class EditCardBingo extends HomeEvent {
  int numberCard;
  bool edit;
  EditCardBingo({required this.edit, required this.numberCard});
}

class DeletePageView extends HomeEvent {
  int numerocard;
  DeletePageView({required this.numerocard});
}

class EditValores extends HomeEvent {
  List<String> val;
  EditValores({required this.val});
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
  int numerCard;
  int numeroButton;
  String valorNumeric;
  OnInsertListValoresNumeric(
      {required this.numerCard,
      required this.valorNumeric,
      required this.numeroButton});
}

class OnInsertListValoresPresionados extends HomeEvent {
  int numerCard;
  int numerButton;
  bool presionado;
  OnInsertListValoresPresionados(
      {required this.numerCard,
      required this.presionado,
      required this.numerButton});
}

class OnInsertButtonEvent extends HomeEvent {
  List<BotonCalculador> lisbton;
  int numerCard;
  OnInsertButtonEvent({required this.lisbton, required this.numerCard});
}

class OnChangeCardEvent extends HomeEvent {
  int numeroCard;
  OnChangeCardEvent({required this.numeroCard});
}
