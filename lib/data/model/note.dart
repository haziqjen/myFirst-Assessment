import 'dart:convert';

Note noteFromJson(String str) => Note.fromJson(json.decode(str));

String noteToJson(Note data) => json.encode(data.toJson());

Map<String, dynamic> noteToMap(Note note) => jsonDecode(jsonEncode(note));

class Note {
  final dynamic id;
  String? title;
  String? content;
  String? uid;

  Note({this.id = 0, this.title = '', this.content = '', this.uid = ''});

  Note.fromJson(Map<String, dynamic> json)
      : this(id: json['id'], title: json['title'], content: json['content']);


  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'content': content, 'uid' : uid};

}
