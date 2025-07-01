import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/screens/game.dart';
import 'package:game/screens/saveBoard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{

  String difficulty = 'Easy';
  List<List<int?>>? savedBoard = null;
  List<List<int?>>? savedClone = null;
  List<List<int?>>? solvedBoard = null;
  String? savedDifficulty = null;
  late var savedData;

  @override
  void initState(){
    super.initState();
    _savedPuzzle();
  }

void _savedPuzzle() async{
  savedData = await SaveBoard.loadPuzzle();
  if (SaveBoard.hasSavedPuzzle == true) {
    savedBoard = savedData['board'];
    savedClone = savedData['clone'];
    solvedBoard = savedData['solution'];
    savedDifficulty = savedData['difficulty'];
  }else{
    savedBoard = null;
    savedClone = null;
    solvedBoard = null;
    savedDifficulty = "Easy";
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[400]?.withAlpha(200),
        surfaceTintColor: Colors.grey[200],

        title: const Text('SUDOKU',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            // fontFamily: ,
          ),
        ),
        centerTitle: true,
      ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.indigo[50]
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Spacer(),

              // first button
              SizedBox(
                width: 225,
                height: 50,
                child: FloatingActionButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Game(solvedBoard: solvedBoard, savedBoard: savedBoard, cloneBoard: savedClone, difficulty: difficulty),
                    ),
                  );
                },

                    backgroundColor: Colors.indigo[300]?.withAlpha(200),
                    elevation: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 25),
                        const Icon(
                          Icons.play_arrow,
                          color: Colors.black,
                          size: 30,
                        ),

                        const SizedBox(width: 15),

                        const Text(
                          'New Game',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                      ],
                    )
                ),
              ),

              const SizedBox(height: 20),

                SizedBox(
                  width: 225,
                  height: 50,
                  child: FloatingActionButton(onPressed: () async{
                    if(SaveBoard.hasSavedPuzzle == true){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Game(solvedBoard: solvedBoard, savedBoard: savedBoard, cloneBoard: savedClone, difficulty: savedDifficulty!),
                        ),
                      );
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No saved game found',
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
                      backgroundColor: Colors.indigo[300]?.withAlpha(200),
                      elevation: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 25),
                          const Icon(
                            Icons.autorenew,
                            color: Colors.black,
                            size: 30,
                          ),

                          const SizedBox(width: 25),

                          const Text(
                            'Resume',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )
                        ],
                      )
                  ),
                ),

              const SizedBox(height: 20),

              //second button
              SizedBox(
                width: 225,
                height: 50,
                child: FloatingActionButton(onPressed: (){
                  showDialog(context: context,
                      barrierColor: Colors.black.withAlpha(155),
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text('Rules',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              // fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content:  Text('1. A number must be unique to its row and its column\n\n'
                              '2. A number must be unique in the 3x3 sub grids.\n\n'
                              'Enjoy solving!!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                  );
                },
                    backgroundColor: Colors.indigo[300]?.withAlpha(200),
                    elevation: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 30),
                        const Icon(
                          Icons.rule_sharp,
                          color: Colors.black,
                          size: 30,
                        ),

                        const SizedBox(width: 30),

                        const Text(
                          'Rules',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                      ],
                    )
                ),
              ),

              const SizedBox(height: 20),

              //third button
              SizedBox(
                width: 225,
                height: 50,
                child: FloatingActionButton(onPressed: (){
                  showDialog(
                      context: context,
                      barrierColor: Colors.black.withAlpha(155),
                      builder: (BuildContext context){
                        return AlertDialog(
                            title: const Text(
                                'Levels',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(onPressed: (){
                                  setState(() {
                                    difficulty = 'Easy';
                                    Navigator.of(context).pop();
                                  });
                                },
                                    child: const Text(
                                        'Easy',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    )
                                ),
                                TextButton(onPressed: (){
                                  setState(() {
                                    difficulty = 'Medium';
                                    Navigator.of(context).pop();
                                  });
                                },
                                    child: const Text(
                                        'Medium',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    )
                                ),
                                TextButton(onPressed: (){
                                  setState(() {
                                    difficulty = 'Hard';
                                    Navigator.of(context).pop();
                                  });
                                },
                                    child: const Text(
                                        'Hard',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    )
                                )
                              ],
                            ),
                        );
                      }
                  );
                },
                    backgroundColor: Colors.indigo[300]?.withAlpha(200),
                    elevation: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 30),
                        const Icon(
                          Icons.numbers,
                          color: Colors.black,
                          size: 30,
                        ),

                        const SizedBox(width: 32),

                        const Text(
                          'Level',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                      ],
                    )
                ),
              ),

              const SizedBox(height: 20),

              //fourth button
              SizedBox(
                width: 225,
                height: 50,
                child: FloatingActionButton(onPressed: (){
                  showDialog(
                      context: context,
                      barrierColor: Colors.black.withAlpha(155),
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: const Text('Exit',
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          content: const Text('Are you sure you want to exit?',
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                // Closes the dialog box
                                /* When Navigator.of(context).pop() is called:
                                        The topmost route (or screen/dialog) is popped off the stack.
                                        The user is taken back to the previous route.*/
                              },
                              child: Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                SystemNavigator.pop();
                                // Closes the app
                              },
                              child: Text("Yes"),
                            ),
                         ]);
                      }
                  );
                },
                    backgroundColor: Colors.indigo[300]?.withAlpha(200),
                    elevation: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 25),
                        const Icon(
                          Icons.door_back_door,
                          color: Colors.black,
                          size: 30,
                        ),

                        const SizedBox(width: 40),

                        const Text(
                          'Exit',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                      ],
                    )
                ),
              ),
                Spacer(),
                const SizedBox(height: 100)
              ]),
          ),
        ));
  }
}