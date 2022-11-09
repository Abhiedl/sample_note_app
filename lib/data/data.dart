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
      final resultAsJson = jsonDecode(result.toString());
      return NoteModel.fromJson(resultAsJson as Map<String, dynamic>);
    } on DioError catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    final result =
        await dio.delete(url.baseUrl + url.deleteNote.replaceFirst('{id}', id));
    if (result.data == null) {
      return;
    }
    final index = noteListNotifier.value.indexWhere((note) => note.id == id);
    if (index == -1) {
      return;
    }
    noteListNotifier.value.removeAt(index);
    noteListNotifier.notifyListeners();
  }

  @override
  Future<List<NoteModel>> getAllNotes() async {
    final result = await dio.get(url.baseUrl + url.getAllNotes);
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
    final result =
        await dio.put(url.baseUrl + url.updateNote, data: value.toJson());
    if (result == null) {
      return null;
    }

    //find index

    final index =
        noteListNotifier.value.indexWhere((note) => note.id == value.id);
    if (index == -1) {
      return null;
    }

    // remove from index

    noteListNotifier.value.removeAt(index);

    // add updatednote to that index

    noteListNotifier.value.insert(index, value);
    noteListNotifier.notifyListeners();
    return value;
  }

  NoteModel? getNoteById(String id) {
    try {
      return noteListNotifier.value.firstWhere((note) => note.id == id);
    } catch (_) {
      return null;
    }
  }
}
