part of 'home_bloc.dart';

class HomeState extends Equatable {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<CardBingo>? listCard; //Lista de tarjetas creadas
  /* List<bool>? estados; */
  int? cantRow;
  int? cantColum;
  int? limitNumber = 90;
  int? numberComodin;
  bool? searchAutomatic;
  late SharedPreferences _preferences;
  HomeState(
      {this.listCard,
      /* this.estados, */
      this.cantColum,
      this.cantRow,
      this.limitNumber,
      this.searchAutomatic,
      this.numberComodin}) {
    /* _preferences = SharedPreferences.getInstance() as SharedPreferences; */
  }

  HomeState copyToWith(
      {List<CardBingo>? listaCards,
      List<bool>? stados,
      int? cantR,
      int? cantCo,
      int? limiNum,
      int? numbCom,
      bool? searchAut}) {
    initial(
        listaCards ?? listCard,
        /* stados ?? estados, */
        cantR ?? cantRow,
        cantCo ?? cantColum,
        limiNum ?? limitNumber,
        numbCom ?? numberComodin,
        searchAut ?? searchAutomatic);
    return HomeState(
        listCard: listaCards ?? listCard,
        /* estados: stados ?? estados, */
        cantRow: cantR ?? cantRow,
        cantColum: cantCo ?? cantColum,
        limitNumber: limiNum ?? limitNumber,
        searchAutomatic: searchAut ?? searchAutomatic,
        numberComodin: numbCom ?? numberComodin);
  }

  Future<void> initial(
      List<CardBingo>? listaCards,
      /* List<bool>? stados, */
      int? cantR,
      int? cantCo,
      int? limiNum,
      int? numbCom,
      bool? searchAut) async {
    final sharedPreferences = await _prefs;
    List<String> lista = [];
    print('imprimir valores');
    if (listaCards != null) {
      for (var i = 0; i < listaCards.length; i++) {
        /* valor = listaCards[i].toMap(); */
        lista.add(jsonEncode(listaCards[i].toMap()));
      }
      sharedPreferences.setStringList('listCard', lista);
    }
    sharedPreferences.setString('col', cantCo.toString());
    sharedPreferences.setString('row', cantRow.toString());
    sharedPreferences.setString('limit', limiNum.toString());
    sharedPreferences.setString('nComodin', numbCom.toString());
    sharedPreferences.setBool('searAut', searchAut!);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        listCard,
        /* estados, */
        cantRow,
        cantColum,
        limitNumber,
        numberComodin,
        searchAutomatic
      ];
}
