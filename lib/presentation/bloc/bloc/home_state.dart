part of 'home_bloc.dart';

class HomeState extends Equatable {
  List<CardBingo>? listCard;
  List<bool>? estados;
  List<String>? valores;
  Map<int, List<bool>>? valoresMarcados;
  HomeState({this.listCard, this.estados, this.valores, this.valoresMarcados});

  HomeState copyToWith(
      {List<CardBingo>? listaCards,
      List<bool>? stados,
      List<String>? valor,
      Map<int, List<bool>>? valMarca}) {
    return HomeState(
        listCard: listaCards ?? listCard,
        estados: stados ?? estados,
        valores: valor ?? valores,
        valoresMarcados: valMarca ?? valoresMarcados);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [listCard, estados, valores, valoresMarcados];

  /* void createListCardButton() {

  
    for (var i = 0; i < 27; i++) {
      listCard![1]!.add(BotonCalculador(
        editar: false,
        numero: i.toString(),
      ));
    }
  } */
}
