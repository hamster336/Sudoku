import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SaveBoard{
  late List<List<int>>? solution;
  late List<List<int?>>? puzzle;
  late List<List<int?>>? clone;
  late String? difficulty;
  static bool hasSavedPuzzle = false;

  SaveBoard(this.puzzle, this.clone, this.difficulty) {
    savePuzzle();
  }

  Future<void> savePuzzle() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'board': puzzle,
      'clone': clone,
      'solution': solution,
      'difficulty': difficulty,
    };
    final boardJson = jsonEncode(data);
    await prefs.setString('saved_puzzle', boardJson);
    await prefs.setBool('has_saved_puzzle', true);
    hasSavedPuzzle = true;
  }

  static Future<Map<String, dynamic>?> loadPuzzle() async {
    final prefs = await SharedPreferences.getInstance();
    final boardJson = prefs.getString('saved_puzzle');

    if (boardJson == null) return null;

    final data = jsonDecode(boardJson);

    List<List<int?>> board = (data['board'] as List)
        .map<List<int?>>((row) => List<int?>.from(row))
        .toList();

    List<List<int?>> clone = (data['clone'] as List)
        .map<List<int?>>((row) => List<int?>.from(row))
        .toList();

    List<List<int>> solution = (data['solution'] as List)
        .map<List<int>>((row) => List<int>.from(row))
        .toList();

    String difficulty = data['difficulty'];

    if(!hasSavedPuzzle) return null;

    return {
      'board': board,
      'clone': clone,
      'solution': solution,
      'difficulty': difficulty,
    };
  }

   void ClearBoard(){
    hasSavedPuzzle = false;
    puzzle = null;
    clone = null;
    solution = null;
    difficulty = null;
  }

  static Future<Map<String, dynamic>?> get loadedPuzzle => loadPuzzle();
}
