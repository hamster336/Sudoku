import 'package:flutter/material.dart';
import 'package:game/screens/game_logic.dart';
import 'package:game/screens/saveBoard.dart';

class Game extends StatefulWidget {
  final String difficulty;
  final List<List<int?>>? savedBoard;
  final List<List<int?>>? cloneBoard;
  final List<List<int?>>? solvedBoard;

  const Game({super.key, required this.savedBoard, required this.cloneBoard, required this.solvedBoard, required this.difficulty});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late bool isSaved;
  GameLogic game = GameLogic();
  bool isSolved = false;
  late List<List<int?>> solvedPuzzle;
  late List<List<int?>> puzzle;
  late List<List<int?>> clone;
  int? selectedRow = null;
  int? selectedCol = null;

  // @override
  // void initState(){
  //   super.initState();
  //   if(SaveBoard.hasSavedPuzzle == true){
  //       solvedPuzzle = widget.solvedBoard as List<List<int>>;
  //       puzzle = (widget.savedBoard) as List<List<int?>>;
  //       clone = (widget.cloneBoard) as List<List<int?>>;
  //   }else{
  //     solvedPuzzle = game.solution;
  //     puzzle = game.removeCells(widget.difficulty);
  //     clone = cloneBoard(puzzle);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    if (SaveBoard.hasSavedPuzzle == true && widget.savedBoard != null && widget.cloneBoard != null && widget.solvedBoard != null) {
      solvedPuzzle = List<List<int?>>.from(widget.solvedBoard!);
      puzzle = List<List<int?>>.from(widget.savedBoard!);
      clone = List<List<int?>>.from(widget.cloneBoard!);
    } else {
      solvedPuzzle = game.solution;
      puzzle = game.removeCells(widget.difficulty);
      clone = cloneBoard(puzzle);
    }
  }

  // Clone function
  List<List<int?>> cloneBoard(List<List<int?>> board) {
    return board.map((row) => List<int?>.from(row)).toList();
  }

  get selectedIndex => null;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo[400]?.withAlpha(200),
            surfaceTintColor: Colors.grey[200],
            title: Text("Level: ${widget.difficulty}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
            actions: [
              PopupMenuButton<String>(
                offset: Offset(100, 55),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: "Save Board",
                    child: Text("Save Board"),
                  ),
                  PopupMenuItem(
                    value: "Clear Board",
                    child: Text("Clear Board"),)
                ],
                icon: Icon(Icons.menu),
                onSelected: (String value){
                  if(value == "Save Board"){
                    SaveBoard(puzzle, clone, solvedPuzzle, widget.difficulty);
                    SaveBoard.hasSavedPuzzle = true;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Board Saved',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                        duration: Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                        elevation: 5,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }else if(value == "Clear Board"){
                    SaveBoard.ClearBoard();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Board Cleared',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                        duration: Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                        elevation: 5,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }
                },
              )
            ],
          ),
          body: Container(
            padding: EdgeInsets.only(left: 2, right: 2),
            color: Colors.indigo[50],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 30),
      
                // Grid to display sudoku
                Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 3,
                        ),
                      ),

                      child: AspectRatio(
                        aspectRatio: 1,
                        child: GridView.builder(
                          itemCount: 9 * 9,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 9,
                          ),
                          itemBuilder: (context, index) {
                            int row = index ~/ 9;
                            int col = index % 9;
      
                            bool isSelected = (row == selectedRow && col == selectedCol);
      
                            return GestureDetector(
                              onTap: () {
                                (clone[row][col] != null)? {} : setState(() {    // makes the filled cells untappable
                                  selectedRow = row;
                                  selectedCol = col;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(width: (row == 0) ? 0 : (row == 3 || row == 6)? 3 : 0.5,
                                                    color: (row == 3 || row == 6)? Colors.black : Colors.black.withAlpha(150) ),
                                    left: BorderSide(width: (col == 0) ? 0 : (col == 3 || col == 6)? 3 : 0.5,
                                                    color: (col == 3 || col == 6)? Colors.black : Colors.black.withAlpha(150)),
                                    right: BorderSide(width: 0.5, color: Colors.black.withAlpha(150)),
                                    bottom: BorderSide(width: 0.5, color: Colors.black.withAlpha(150)),
                                  ),
                                  color: isSelected? Colors.grey : (clone[row][col] != null)? Colors.indigo[300]?.withAlpha(200) : Colors.white,
                                ),
      
                                child: Center(
                                  child: Text( (puzzle[row][col] == null)? '' : '${puzzle[row][col]}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ),
      
                const SizedBox(height: 15),
      
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(width: 10),
      
                      SizedBox(
                        width: 70,
                        child: FloatingActionButton(onPressed: (){
                          showDialog(
                              context: context,
                              barrierColor: Colors.black.withAlpha(155),
                              builder: (BuildContext context){
                                return AlertDialog(
                                    title: const Text('Solve'),
                                    content: const Text('Do you want the puzzle to be solved?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          // Closes the dialog box
                                        },
                                        child: Text("No"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            puzzle = solvedPuzzle;
                                            isSolved = true;
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: Text("Yes"),
                                      ),
                                    ]);
                              }
                          );
                        },
                          backgroundColor: Colors.indigo[300]?.withAlpha(200),
                          child: const Text('Solve',
                            style: TextStyle(
                                fontSize: 18,
                              color: Colors.black
                            )
                          ),
                        ),
                      ),
      
                      Spacer(),
                      
                      Text('Enjoy Solving!!',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
      
                      SizedBox(
                        width: 70,
                        child: FloatingActionButton(onPressed: (){
                          (isSolved)? {
                            showDialog(context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: const Text('Not valid!!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        )
                                    ),

                                    content: const Text('You have used the solver.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                        )
                                    ),
                                  );
                                })
                          }
                              :    // submit button works only if the puzzle is not solved using the solver
                          (isCorrect(puzzle, clone))?
                          showDialog(context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: const Text('Congratulations!!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),

                                  content: const Text('You have found the solution!!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                      )
                                  ),
                                );
                              })
                              :
                          showDialog(context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: const Text('Ooops..',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),
                                  content: const Text('This solution is incorrect.\nTry again....',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                      )
                                  ),
                                );
                              });
                        },
                          backgroundColor: Colors.indigo[300]?.withAlpha(200),
                          child: const Text('Submit',
                            style: TextStyle(
                                fontSize: 18,
                              color: Colors.black
                            ),
                          ),
                        ),
                      ),
      
                      const SizedBox(width: 10)
                    ]
                ),
      
                // const SizedBox(height: 30),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(onPressed: (){
                      setState(() {
                        puzzle[selectedRow!][selectedCol!] = 1;
                      });
                    },
                      backgroundColor: Colors.indigo[300]?.withAlpha(200),
                      child: Text('1',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),),
                    ),
      
                    const SizedBox(width: 10),
      
                    FloatingActionButton(onPressed: (){
                      setState(() {
                        puzzle[selectedRow!][selectedCol!] = 2;
                      });
                    },
                      backgroundColor: Colors.indigo[300]?.withAlpha(200),
                      child: Text('2',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),),
                    ),
      
                    const SizedBox(width: 10),
      
                    FloatingActionButton(onPressed: (){
                      setState(() {
                        puzzle[selectedRow!][selectedCol!] = 3;
                      });
                    },
                      backgroundColor: Colors.indigo[300]?.withAlpha(200),
                      child: Text('3',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),),
                    ),
      
                    const SizedBox(width: 10),
      
                    FloatingActionButton(onPressed: (){
                      setState(() {
                        puzzle[selectedRow!][selectedCol!] = 4;
                      });
                    },
                      backgroundColor: Colors.indigo[300]?.withAlpha(200),
                      child: Text('4',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),),
                    ),
      
                    const SizedBox(width: 10),
      
                    FloatingActionButton(onPressed: (){
                      setState(() {
                        puzzle[selectedRow!][selectedCol!] = 5;
                      });
                    },
                      backgroundColor: Colors.indigo[300]?.withAlpha(200),
                      child: Text('5',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),),
                    ),
                  ],
                ),
      
                const SizedBox(height: 10),
      
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(onPressed: (){
                      setState(() {
                        puzzle[selectedRow!][selectedCol!] = 6;
                      });
                    },
                      backgroundColor: Colors.indigo[300]?.withAlpha(200),
                      child: Text('6',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),),
                    ),
      
                    const SizedBox(width: 10),
      
                    FloatingActionButton(onPressed: (){
                      setState(() {
                        puzzle[selectedRow!][selectedCol!] = 7;
                      });
                    },
                      backgroundColor: Colors.indigo[300]?.withAlpha(200),
                      child: Text('7',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),),
                    ),
      
                    const SizedBox(width: 10),
      
                    FloatingActionButton(onPressed: (){
                      setState(() {
                        puzzle[selectedRow!][selectedCol!] = 8;
                      });
                    },
                      backgroundColor: Colors.indigo[300]?.withAlpha(200),
                      child: Text('8',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),),
                    ),
      
                    const SizedBox(width: 10),
      
                    FloatingActionButton(onPressed: (){
                      setState(() {
                        puzzle[selectedRow!][selectedCol!] = 9;
                      });
                    },
                      backgroundColor: Colors.indigo[300]?.withAlpha(200),
                      child: Text('9',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),),
                    ),
                    
                    const SizedBox(width: 10),
      
                    FloatingActionButton(onPressed: (){
                      setState(() {
                        puzzle[selectedRow!][selectedCol!] = null;
                      });
                    },
                        backgroundColor: Colors.indigo[300]?.withAlpha(200),
                      child: const Text('Clear',
                        style: TextStyle(
                          color: Colors.black
                        ),
                      )
                    ),
                  ],
                ),
      
                Spacer(),
                const SizedBox(height: 20),
              ],
            ),
          )),
    );
  }

  bool isCorrect(List<List<int?>> puzzle, List<List<int?>> clone){
    for(int i=0; i<9; i++){
      for(int j=0; j<9; j++){
        if(clone[i][j] == null){
          if(!isSafe(puzzle, i, j, puzzle[i][j])){
            return false;
          }
        }
      }
    }
    return true;
  }

  bool isSafe(List<List<int?>> puzzle, int row, int col, int? num) {
    for (int x = 0; x < 9; x++) {
      if (x != col && puzzle[row][x] == num) return false; // check the entire row, but skip the current column
      if (x != row && puzzle[x][col] == num) return false; // check the entire column, but skip the current row
    }

    int startRow = 3 * (row ~/ 3);
    int startCol = 3 * (col ~/ 3);

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        int currentRow = startRow + i;
        int currentCol = startCol + j;
        if ((currentRow != row || currentCol != col) &&
            puzzle[currentRow][currentCol] == num) {
          return false; // check box, but skip the current cell
        }
      }
    }

    return true;
  }
}