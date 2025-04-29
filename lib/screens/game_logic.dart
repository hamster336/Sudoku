// import 'dart:math';
//
// class GameLogic {
//   final Random _random = Random();
//   late List<List<int?>> _puzzle; // Only one board now!
//
//   GameLogic(String difficulty) {
//     _puzzle = _generatePuzzle(difficulty);
//   }
//
//   /// Generates a full Sudoku and removes cells based on difficulty
//   List<List<int?>> _generatePuzzle(String difficulty) {
//     List<List<int?>> board = List.generate(9, (_) => List.filled(9, null));
//
//     bool isSafe(List<List<int?>> board, int row, int col, int num) {
//       for (int x = 0; x < 9; x++) {
//         if (board[row][x] == num || board[x][col] == num ||
//             board[3 * (row ~/ 3) + x ~/ 3][3 * (col ~/ 3) + x % 3] == num) {
//           return false;
//         }
//       }
//       return true;
//     }
//
//     bool fillBoard(List<List<int?>> board) {
//       for (int row = 0; row < 9; row++) {
//         for (int col = 0; col < 9; col++) {
//           if (board[row][col] == null) {
//             List<int> numbers = List.generate(9, (index) => index + 1)..shuffle();
//             for (int number in numbers) {
//               if (isSafe(board, row, col, number)) {
//                 board[row][col] = number;
//                 if (fillBoard(board)) return true;
//                 board[row][col] = null;
//               }
//             }
//             return false;
//           }
//         }
//       }
//       return true;
//     }
//
//     fillBoard(board);
//
//     // Remove cells based on difficulty
//     int cellsToRemove = switch (difficulty) {
//       'Easy' => (81 * 0.30).round(),    // removes 30% of the cells
//       'Medium' => (81 * 0.45).round(),  // removes 45% of the cells
//       'Hard' => (81 * 0.60).round(),    // removes 60% of the cells
//       _ => throw ArgumentError("Invalid difficulty: Choose 'Easy', 'Medium', or 'Hard'"),
//     };
//
//     while (cellsToRemove > 0) {
//       int row = _random.nextInt(9);
//       int col = _random.nextInt(9);
//       if (board[row][col] != null) {
//         board[row][col] = null;
//         cellsToRemove--;
//       }
//     }
//
//     return board;
//   }
//
//   /// Returns the current puzzle board
//   List<List<int?>> get puzzle => _puzzle;
// }

import 'dart:math';

class GameLogic {
  final Random _random = Random();
  late List<List<int?>> _solution; // Stores the fully solved Sudoku

  GameLogic() {
    _solution = _generateSolvedSudoku(); // Generate solution on initialization
  }

  /// Generates a fully solved Sudoku board
  List<List<int?>> _generateSolvedSudoku() {
    List<List<int?>> board = List.generate(9, (_) => List.filled(9, null));

    bool isSafe(List<List<int?>> board, int row, int col, int num) {
      for (int x = 0; x < 9; x++) {
        if (board[row][x] == num || board[x][col] == num ||
            board[3 * (row ~/ 3) + x ~/ 3][3 * (col ~/ 3) + x % 3] == num) {
          return false;
        }
      }
      return true;
    }

    bool fillBoard(List<List<int?>> board) {
      for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
          if (board[row][col] == null) {
            List<int> numbers = List.generate(9, (index) => index + 1)..shuffle();
            for (int number in numbers) {
              if (isSafe(board, row, col, number)) {
                board[row][col] = number;
                if (fillBoard(board)) return true;
                board[row][col] = null;
              }
            }
            return false;
          }
        }
      }
      return true;
    }

    fillBoard(board);
    return board;
  }

  /// Removes numbers from the solved board to create a Sudoku puzzle
  List<List<int?>> removeCells(String difficulty) {
    List<List<int?>> puzzle = _solution.map((row) => List<int?>.from(row)).toList();

    // Decide how many cells to remove
    int cellsToRemove = switch (difficulty) {
      'Easy' => (81 * 0.30).round(),
      'Medium' => (81 * 0.45).round(),
      'Hard' => (81 * 0.60).round(),
      _ => throw ArgumentError("Invalid difficulty: Choose 'Easy', 'Medium', or 'Hard'"),
    };

    while (cellsToRemove > 0) {
      int row = _random.nextInt(9);
      int col = _random.nextInt(9);
      if (puzzle[row][col] != null) {
        puzzle[row][col] = null;
        cellsToRemove--;
      }
    }

    return puzzle;
  }

  /// Returns the solved Sudoku for reference
  List<List<int?>> get solution => _solution;
}
