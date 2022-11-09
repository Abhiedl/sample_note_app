import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_app/data/get_all_notes_resp/get_all_notes_resp.dart';
import 'package:note_app/data/note_model/note_model.dart';
import 'package:note_app/data/url.dart';

abstract class ApiCalls {
  Future<NoteModel?> createNote(NoteModel value);
  Future<List<NoteModel>> getAllNotes();
  Future<NoteModel?> updateNote(NoteModel value);
  Future<void> deleteNote(String id);
}

class NoteDB extends ApiCalls {
  // singleton opens

  NoteDB._internal();

  static NoteDB instance = NoteDB._internal();

  NoteDB factory() {
    return instance;
  }

  // singleton closes
  final dio = Dio();
  final url = Url();

  ValueNotifier<List<NoteModel>> noteListNotifier = ValueNotifier([]);

  // NoteDB() {
  //   dio.options = BaseOptions(
  //     baseUrl: url.baseUrl,
  //     responseType: ResponseType.plain,
  //   );
  // }
  @override
  Future<NoteModel?> createNote(NoteModel value) async {
    try {
      final result = await dio.post(
        url.baseUrl + url.createNote,
        data: value.toJson(),
      );
      print(result.data);
      final resultAsJson = jsonDecode(result.toString());
      return NoteModel.fromJson(resultAsJson as Map<String, dynamic>);
    } on DioError catch (e) {
      print(e.response?.data);
      print(e);
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    // TODO: implement deleteNote
    throw UnimplementedError();
  }

  @override
  Future<List<NoteModel>> getAllNotes() async {
    final result = await dio.get(url.baseUrl + url.getAllNotes);
    print(result.data.toString());
    final resultAsJson = jsonDecode(result.toString());
    if (resultAsJson != null) {
      final getNoteResp = GetAllNotesResp.fromJson(resultAsJson);
      noteListNotifier.value.clear();
      noteListNotifier.value.addAll(getNoteResp.data.reversed);
      noteListNotifier.notifyListeners();
      return getNoteResp.data;
    } else {
      noteListNotifier.value.clear();
      return [];
    }
  }

  @override
  Future<NoteModel?> updateNote(NoteModel value) async {
    // TODO: implement updateNote
    throw UnimplementedError();
  }
}
