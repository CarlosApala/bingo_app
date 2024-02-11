// To parse this JSON data, do
//
//     final listCard = listCardFromJson(jsonString);

import 'dart:convert';

List<ListCard> listCardFromJson(String str) =>
    List<ListCard>.from(json.decode(str).map((x) => ListCard.fromJson(x)));

String listCardToJson(List<ListCard> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListCard {
  int numberCard;
  List<ListButton> listButton;

  ListCard({
    required this.numberCard,
    required this.listButton,
  });

  factory ListCard.fromJson(Map<String, dynamic> json) => ListCard(
        numberCard: json["numberCard"],
        listButton: List<ListButton>.from(
            json["listButton"].map((x) => ListButton.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "numberCard": numberCard,
        "listButton": List<dynamic>.from(listButton.map((x) => x.toJson())),
      };
}

class ListButton {
  bool presionado;
  String valornumerico;

  ListButton({
    required this.presionado,
    required this.valornumerico,
  });

  factory ListButton.fromJson(Map<String, dynamic> json) => ListButton(
        presionado: json["presionado"],
        valornumerico: json["valornumerico"],
      );

  Map<String, dynamic> toJson() => {
        "presionado": presionado,
        "valornumerico": valornumerico,
      };
}
