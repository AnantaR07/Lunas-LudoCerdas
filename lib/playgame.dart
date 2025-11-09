import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:ui'; // untuk BackdropFilter

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final int gridSize = 15;

  final Map<int, List<Offset>> basePawns = {
    0: [Offset(1, 1), Offset(1, 3), Offset(3, 1), Offset(3, 3)],
    1: [Offset(1, 11), Offset(1, 13), Offset(3, 11), Offset(3, 13)],
    2: [Offset(11, 11), Offset(11, 13), Offset(13, 11), Offset(13, 13)],
    3: [Offset(11, 1), Offset(11, 3), Offset(13, 1), Offset(13, 3)],
  };

  final Map<String, int> playerPoints = {
    'Merah': 0,

    'Biru': 0,

    'Hijau': 0,

    'Kuning': 0,
  };

  final Map<String, int> playerPiecesFinished = {
    'Merah': 0,

    'Biru': 0,

    'Hijau': 0,

    'Kuning': 0,
  };

  final Map<Offset, Map<String, dynamic>> materialTiles = {
    // Merah
    Offset(6, 2): {
      "type": "materi",
      "image": "assets/images/card/KartuMateri1.jpeg",
    },
    Offset(6, 5): {
      "type": "materi",
      "image": "assets/images/card/KartuMateri2.jpeg",
    },
    Offset(3, 6): {
      "type": "materi",
      "image": "assets/images/card/KartuMateri3.jpeg",
    },
    // Hijau
    Offset(3, 8): {
      "type": "materi",
      "image": "assets/images/card/KartuMateri4.jpeg",
    },
    Offset(4, 8): {
      "type": "materi",
      "image": "assets/images/card/KartuMateri5.jpeg",
    },
    Offset(6, 12): {
      "type": "materi",
      "image": "assets/images/card/KartuMateri6.jpeg",
    },
    // Kuning
    Offset(8, 11): {
      "type": "materi",
      "image": "assets/images/card/KartuMateri7.jpeg",
    },
    Offset(8, 10): {
      "type": "materi",
      "image": "assets/images/card/KartuMateri8.jpeg",
    },
    Offset(10, 8): {
      "type": "materi",
      "image": "assets/images/card/KartuMateri9.jpeg",
    },
    // Biru
    Offset(10, 6): {
      "type": "materi",
      "image": "assets/images/card/KartuMateri10.jpeg",
    },
    Offset(11, 6): {
      "type": "materi",
      "image": "assets/images/card/KartuMateri11.jpeg",
    },
    Offset(12, 6): {
      "type": "materi",
      "image": "assets/images/card/KartuMateri12.jpeg",
    },
  };

  final Map<Offset, Map<String, dynamic>> luckyTiles = {
    // Merah
    Offset(5, 6): {
      "type": "keberuntungan",
      "image": "assets/images/card/KartuKeberuntungan1.jpeg",
      "answer": "Hidung",
    },
    // Hijau
    Offset(6, 9): {
      "type": "keberuntungan",
      "image": "assets/images/card/KartuKeberuntungan2.jpeg",
      "answer": "Bulu Hidung",
    },
    // Kuning
    Offset(8, 9): {
      "type": "keberuntungan",
      "image": "assets/images/card/KartuKeberuntungan3.jpeg",
      "answer": "Hidung->Faring->Laring->Trakea->Paru->Paru->Alveolus",
    },
    // Biru
    Offset(8, 2): {
      "type": "keberuntungan",
      "image": "assets/images/card/KartuKeberuntungan4.jpeg",
      "answer": "Berolahraga",
    },
  };

  final Map<Offset, Map<String, dynamic>> quizTiles = {
    // Merah Biru
    Offset(7, 0): {
      "type": "quiz",
      "image": "assets/images/card/KartuPertanyaan1.jpeg",
      "answer": "Hidung",
    },
    Offset(0, 6): {
      "type": "quiz",
      "image": "assets/images/card/KartuPertanyaan2.jpeg",
      "answer": "Bronkus dan Bronkiolus",
    },
    // Merah Hijau
    Offset(0, 7): {
      "type": "quiz",
      "image": "assets/images/card/KartuPertanyaan3.jpeg",
      "answer": "Segera Menjauh dari Sumber Asap",
    },
    // Hijau Kuning
    Offset(7, 14): {
      "type": "quiz",
      "image": "assets/images/card/KartuPertanyaan4.jpeg",
      "answer": "Paru-paru",
    },
    // Kuning Biru
    Offset(14, 7): {
      "type": "quiz",
      "image": "assets/images/card/KartuPertanyaan5.jpeg",
      "answer": "Paru-paru",
    },
  };

  final Map<Offset, Map<String, dynamic>> timeTiles = {
    // Merah
    Offset(6, 3): {
      "type": "time",
      "image": "assets/images/card/KartuWaktu1.jpeg",
      "answer": "Hidung",
    },
    // Hijau
    Offset(5, 8): {
      "type": "time",
      "image": "assets/images/card/KartuWaktu2.jpeg",
      "answer": "Sebagai Otot Pernapasan Utama",
    },
    // Kuning
    Offset(11, 8): {
      "type": "time",
      "image": "assets/images/card/KartuWaktu3.jpeg",
      "answer": "Otot Diafragma Dan Otot Antar Tulang Rusuk Berkontraksi",
    },
    Offset(12, 8): {
      "type": "time",
      "image": "assets/images/card/KartuWaktu4.jpeg",
      "answer": "Trakea",
    },
    // Biru
    Offset(8, 4): {
      "type": "time",
      "image": "assets/images/card/KartuWaktu5.jpeg",
      "answer": "Hidung",
    },
  };

  Map<int, List<Offset>> pawnPositions = {};
  Map<int, List<int>> pawnPathIndex = {};
  Map<int, int> playerSteps = {};
  Map<Offset, List<int>> positionEntryOrder = {};
  int currentDiceRoll = 0;
  int currentPlayerTurn = 0;
  final Map<Offset, int> positionOccupants = {};
  bool hasRolledDice = false;
  bool isGameOver = false;
  String? winnerName;

  void _showResultDialogWinner(String message, {String? winner, int? points}) {
    final playerColor = winner != null
        ? _playerColorByName(winner)
        : Colors.blue;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: playerColor.withOpacity(0.85),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: playerColor.withOpacity(0.6),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    winner != null ? Icons.emoji_events : Icons.info_outline,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    winner != null ? "Pemenang: $winner" : "Perhatian!",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (points != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      "Jumlah Poin: $points",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    message,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: playerColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                      shadowColor: playerColor.withOpacity(0.5),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      "Tutup",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper untuk dapatkan warna dari nama pemain
  Color _playerColorByName(String name) {
    switch (name.toLowerCase()) {
      case 'merah':
        return Colors.red;
      case 'hijau':
        return Colors.green;
      case 'kuning':
        return Colors.amber[800]!;
      case 'biru':
        return Colors.blue;
      default:
        return Colors.blueGrey;
    }
  }

  final List<Offset> ludoPath = [
    Offset(6, 0),
    Offset(6, 1),
    Offset(6, 2),
    Offset(6, 3),
    Offset(6, 4),
    Offset(6, 5),
    Offset(5, 6),
    Offset(4, 6),
    Offset(3, 6),
    Offset(2, 6),
    Offset(1, 6),
    Offset(0, 6),
    Offset(0, 7),
    Offset(1, 7),
    Offset(2, 7),
    Offset(3, 7),
    Offset(4, 7),
    Offset(5, 7),
    Offset(6, 8),
    Offset(6, 9),
    Offset(6, 10),
    Offset(6, 11),
    Offset(6, 12),
    Offset(6, 13),
    Offset(6, 14),
    Offset(7, 14),
    Offset(7, 13),
    Offset(7, 12),
    Offset(7, 11),
    Offset(7, 10),
    Offset(7, 9),
    Offset(7, 8),
    Offset(8, 7),
    Offset(9, 7),
    Offset(10, 7),
    Offset(11, 7),
    Offset(12, 7),
    Offset(13, 7),
    Offset(14, 7),
    Offset(14, 6),
    Offset(13, 6),
    Offset(12, 6),
    Offset(11, 6),
    Offset(10, 6),
    Offset(9, 6),
    Offset(8, 6),
    Offset(7, 5),
    Offset(7, 4),
    Offset(7, 3),
    Offset(7, 2),
    Offset(7, 1),
    Offset(7, 0),
  ];

  bool get canMovePawn {
    return pawnPositions[currentPlayerTurn]!.any(
          (pos) => !_isInBase(currentPlayerTurn, pos),
        ) ||
        currentDiceRoll == 6;
  }

  bool _isInBase(int player, Offset position) {
    return basePawns[player]!.any(
      (base) =>
          (base.dx - position.dx).abs() < 0.01 &&
          (base.dy - position.dy).abs() < 0.01,
    );
  }

  bool get hasPawnsOnTrack {
    return pawnPositions.entries.any((entry) {
      final player = entry.key;

      return entry.value.any((position) => !_isInBase(player, position));
    });
  }

  @override
  void initState() {
    super.initState();

    pawnPositions = {
      0: List.from(basePawns[0]!),

      1: List.from(basePawns[1]!),

      2: List.from(basePawns[2]!),

      3: List.from(basePawns[3]!),
    };

    pawnPathIndex = {
      0: List.generate(4, (_) => 0),

      1: List.generate(4, (_) => 0),

      2: List.generate(4, (_) => 0),

      3: List.generate(4, (_) => 0),
    };

    // Inisialisasi playerSteps dengan 0 untuk setiap pemain

    playerSteps = {0: 0, 1: 0, 2: 0, 3: 0};
  }

  List<Offset> _getPlayerPath(int player) {
    // Define the full path for each player based on their starting color

    switch (player) {
      case 0: // Merah

        return [
          Offset(6, 1),
          Offset(6, 2),
          Offset(6, 3),
          Offset(6, 4),
          Offset(6, 5),

          Offset(5, 6),
          Offset(4, 6),
          Offset(3, 6),
          Offset(2, 6),
          Offset(1, 6),
          Offset(0, 6),

          Offset(0, 7),

          Offset(0, 8),
          Offset(1, 8),
          Offset(2, 8),
          Offset(3, 8),
          Offset(4, 8),
          Offset(5, 8),

          Offset(6, 9),
          Offset(6, 10),
          Offset(6, 11),
          Offset(6, 12),
          Offset(6, 13),
          Offset(6, 14),

          Offset(7, 14),

          Offset(8, 14),
          Offset(8, 13),
          Offset(8, 12),
          Offset(8, 11),
          Offset(8, 10),
          Offset(8, 9),

          Offset(9, 8),
          Offset(10, 8),
          Offset(11, 8),
          Offset(12, 8),
          Offset(13, 8),
          Offset(14, 8),

          Offset(14, 7),

          Offset(14, 6),
          Offset(13, 6),
          Offset(12, 6),
          Offset(11, 6),
          Offset(10, 6),
          Offset(9, 6),

          Offset(8, 5),
          Offset(8, 4),
          Offset(8, 3),
          Offset(8, 2),
          Offset(8, 1),
          Offset(8, 0),

          Offset(7, 0),

          Offset(6, 0),
          Offset(6, 1),
          Offset(7, 1), // Kembali ke Merah
          Offset(7, 2),
          Offset(7, 3),
          Offset(7, 4),
          Offset(7, 5),
          Offset(6, 6), // Finish Merah
        ];

      case 1: // Hijau

        return [
          Offset(1, 8),
          Offset(2, 8),
          Offset(3, 8),
          Offset(4, 8),
          Offset(5, 8),

          Offset(6, 9),
          Offset(6, 10),
          Offset(6, 11),
          Offset(6, 12),
          Offset(6, 13),
          Offset(6, 14),

          Offset(7, 14),

          Offset(8, 14),
          Offset(8, 13),
          Offset(8, 12),
          Offset(8, 11),
          Offset(8, 10),
          Offset(8, 9),

          Offset(9, 8),

          Offset(10, 8),
          Offset(11, 8),
          Offset(12, 8),
          Offset(13, 8),
          Offset(14, 8),

          Offset(14, 7),

          Offset(14, 6),
          Offset(13, 6),
          Offset(12, 6),
          Offset(11, 6),
          Offset(10, 6),
          Offset(9, 6),

          Offset(8, 5),

          Offset(8, 4),
          Offset(8, 3),
          Offset(8, 2),
          Offset(8, 1),
          Offset(8, 0),

          Offset(7, 0),

          Offset(6, 0),
          Offset(6, 1),
          Offset(6, 2),
          Offset(6, 3),
          Offset(6, 4),
          Offset(6, 5),

          Offset(5, 6),
          Offset(4, 6),
          Offset(3, 6),
          Offset(2, 6),
          Offset(1, 6),
          Offset(0, 6),

          Offset(0, 7),
          Offset(0, 8),
          Offset(1, 8), // Kembali ke Hijau
          Offset(1, 7),
          Offset(2, 7),
          Offset(3, 7),
          Offset(4, 7),
          Offset(5, 7),
          Offset(6, 8), // Finish Hijau
        ];

      case 2: // Kuning

        return [
          Offset(8, 13),
          Offset(8, 12),
          Offset(8, 11),
          Offset(8, 10),
          Offset(8, 9),

          Offset(9, 8),

          Offset(10, 8),
          Offset(11, 8),
          Offset(12, 8),
          Offset(13, 8),
          Offset(14, 8),

          Offset(14, 7),

          Offset(14, 6),
          Offset(13, 6),
          Offset(12, 6),
          Offset(11, 6),
          Offset(10, 6),
          Offset(9, 6),

          Offset(8, 5),

          Offset(8, 4),
          Offset(8, 3),
          Offset(8, 2),
          Offset(8, 1),
          Offset(8, 0),

          Offset(7, 0),

          Offset(6, 0),
          Offset(6, 1),
          Offset(6, 2),
          Offset(6, 3),
          Offset(6, 4),
          Offset(6, 5),

          Offset(5, 6),

          Offset(4, 6),
          Offset(3, 6),
          Offset(2, 6),
          Offset(1, 6),
          Offset(0, 6),

          Offset(0, 7),

          Offset(0, 8),
          Offset(1, 8),
          Offset(2, 8),
          Offset(3, 8),
          Offset(4, 8),
          Offset(5, 8),

          Offset(6, 9),
          Offset(6, 10),
          Offset(6, 11),
          Offset(6, 12),
          Offset(6, 13),
          Offset(6, 14),

          Offset(7, 14),

          Offset(8, 14),
          Offset(8, 13), // Kembali ke Kuning
          Offset(7, 13),
          Offset(7, 12),
          Offset(7, 11),
          Offset(7, 10),
          Offset(7, 9),

          Offset(8, 8), // Finish Kuning
        ];

      case 3: // Biru

        return [
          Offset(13, 6),
          Offset(12, 6),
          Offset(11, 6),
          Offset(10, 6),
          Offset(9, 6),

          Offset(8, 5),

          Offset(8, 4),
          Offset(8, 3),
          Offset(8, 2),
          Offset(8, 1),
          Offset(8, 0),

          Offset(7, 0),

          Offset(6, 0),
          Offset(6, 1),
          Offset(6, 2),
          Offset(6, 3),
          Offset(6, 4),
          Offset(6, 5),

          Offset(5, 6),

          Offset(4, 6),
          Offset(3, 6),
          Offset(2, 6),
          Offset(1, 6),
          Offset(0, 6),

          Offset(0, 7),

          Offset(0, 8),
          Offset(1, 8),
          Offset(2, 8),
          Offset(3, 8),
          Offset(4, 8),
          Offset(5, 8),

          Offset(6, 9),
          Offset(6, 10),
          Offset(6, 11),
          Offset(6, 12),
          Offset(6, 13),
          Offset(6, 14),

          Offset(7, 14),
          Offset(8, 14),
          Offset(8, 13),
          Offset(8, 12),
          Offset(8, 11),
          Offset(8, 10),
          Offset(8, 9),

          Offset(9, 8),
          Offset(10, 8),
          Offset(11, 8),
          Offset(12, 8),
          Offset(13, 8),
          Offset(14, 8),

          Offset(14, 7),

          Offset(14, 6), // Kembali ke Biru
          Offset(13, 6),
          Offset(13, 7),
          Offset(12, 7),
          Offset(11, 7),
          Offset(10, 7),
          Offset(9, 7),

          Offset(8, 6), // Finish Biru
        ];

      default:
        return [];
    }
  }

  Future<void> _showMaterialDialog(
    Offset offset,
    int player,
    int pawnIndex,
  ) async {
    final tileData = materialTiles[offset];

    if (tileData != null) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Kartu Materi",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent, // Change title color
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // Responsive width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    tileData["image"],
                    fit: BoxFit
                        .cover, // Change to cover for better image display
                    height: 150, // Set a fixed height for the image
                    width: double.infinity, // Make image take full width
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Change button color
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ), // Adjust padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5, // Add elevation for shadow effect
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // Move the pawn according to the rolled dice
                await movePawnAlongPath(player, pawnIndex, currentDiceRoll);

                // Reset the dice status
                setState(() {
                  currentDiceRoll = 0; // Reset the dice
                  hasRolledDice = false; // Allow rolling again
                  // Change to the next player
                  currentPlayerTurn =
                      (currentPlayerTurn + 1) % 4; // Switch to the next player
                });
              },
              child: const Text("Lanjut Jalan"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _showQuestionDialog(Offset tilePosition, int player) async {
    final luckyTileData = luckyTiles[tilePosition];

    if (luckyTileData != null) {
      // Find the index of the pawn on this tile
      int? pawnIndex;

      // Iterate through all pawns of this player
      for (int i = 0; i < pawnPositions[player]!.length; i++) {
        if (pawnPositions[player]![i] == tilePosition) {
          pawnIndex = i;
          break;
        }
      }

      // Exit if no pawn found on this tile
      if (pawnIndex == null) return;

      // Get the image and answer from the lucky tile data
      String imagePath = luckyTileData["image"];
      String answer = luckyTileData["answer"];

      // Define questions and options based on the answer
      List<String> options;
      String correctAnswer;

      // Use if statements instead of switch
      if (tilePosition == Offset(5, 6)) {
        options = ["A. Hidung", "B. Kaki", "C. Tangan", "D. Udara"];
        correctAnswer = "A. Hidung";
      } else if (tilePosition == Offset(6, 9)) {
        options = [
          "A. Jari",
          "B. Tenggorokan",
          "C. Bulu Hidung",
          "D. Paru-Paru",
        ];
        correctAnswer = "C. Bulu Hidung";
      } else if (tilePosition == Offset(8, 9)) {
        options = [
          "A. Hidung->Tenggorokan->Paru-Paru->Faring",
          "B. Hidung->Faring->Trakea->Paru-Paru",
          "C. Faring->Hidung->Laring->Trakea",
          "D. Trakea->Hidung->Laring->Alveolus",
        ];
        correctAnswer = "B. Hidung->Faring->Trakea->Paru-Paru";
      } else if (tilePosition == Offset(8, 2)) {
        options = [
          "A. Berolahraga",
          "B. Makan Banyak",
          "C. Minum Banyak",
          "D. Tidur",
        ];
        correctAnswer = "A. Berolahraga";
      } else {
        return; // Exit if no matching tile
      }

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Pertanyaan Keberuntungan",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent, // Change title color
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // Responsive width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit
                        .cover, // Change to cover for better image display
                    height: 150, // Set a fixed height for the image
                    width: double.infinity, // Make image take full width
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Pilih jawaban yang benar:",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ), // Change text color
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ...options.map((option) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(option),
                      onTap: () async {
                        Navigator.of(context).pop(); // Close the dialog
                        if (option == correctAnswer) {
                          _showResultDialog(
                            "Jawaban benar! Anda mendapatkan 20 poin.",
                          );
                          setState(() {
                            playerSteps[player] =
                                (playerSteps[player] ?? 0) +
                                20; // Add 20 points
                            hasRolledDice = false; // Disable rolling again
                          });
                        } else {
                          _showResultDialog("Jawaban salah!");
                        }

                        // Move the player based on the current dice roll
                        await movePawnAlongPath(
                          player,
                          pawnIndex!, // Use the correct pawnIndex
                          currentDiceRoll,
                        );

                        setState(() {
                          currentPlayerTurn =
                              (currentPlayerTurn + 1) % 4; // Change player turn
                          hasRolledDice = false; // Reset dice status
                          currentDiceRoll = 0; // Reset dice
                        });
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<void> showWinnerDialog(String winner, int points) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Pemenang: $winner"),
        content: Text("Jumlah Poin: $points"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Bisa reset game atau kembali ke menu
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _showQuiznDialog(Offset tilePosition, int player) async {
    final quizData = quizTiles[tilePosition];

    if (quizData != null) {
      // Find the index of the pawn on this tile
      int? pawnIndex;

      // Iterate through all pawns of this player
      for (int i = 0; i < pawnPositions[player]!.length; i++) {
        if (pawnPositions[player]![i] == tilePosition) {
          pawnIndex = i;
          break;
        }
      }

      // Exit if no pawn found on this tile
      if (pawnIndex == null) return;

      // Get the image and answer from the quiz data
      String imagePath = quizData["image"];
      String answer = quizData["answer"];

      // Define questions and options based on the answer
      List<String> options;
      String correctAnswer;

      // Use if statements instead of switch
      if (tilePosition == Offset(7, 0)) {
        options = ["A. Dada", "B. Kepala", "C. Hidung", "D. Tenggorokan"];
        correctAnswer = "C. Hidung";
      } else if (tilePosition == Offset(0, 6)) {
        options = [
          "A. Hidung",
          "B. Tangan",
          "C. Bronkus dan Bronkiolus",
          "D. Kaki",
        ];
        correctAnswer = "C. Bronkus dan Bronkiolus";
      } else if (tilePosition == Offset(0, 7)) {
        options = [
          "A. Berteriak Minta Tolong",
          "B. Mendekati Area Asap",
          "C. Berbaring",
          "D. Segera Menjauh dari Sumber Asap",
        ];
        correctAnswer = "D. Segera Menjauh dari Sumber Asap";
      } else if (tilePosition == Offset(7, 14)) {
        options = ["A. Tenggorokan", "B. Paru-paru", "C. Jantung", "D. Hidung"];
        correctAnswer = "B. Paru-paru";
      } else if (tilePosition == Offset(14, 7)) {
        options = ["A. Hidung", "B. Paru-paru", "C. Jantung", "D. Tenggorokan"];
        correctAnswer = "B. Paru-paru";
      } else {
        return; // Exit if no matching tile
      }

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Pertanyaan Keberuntungan",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent, // Change title color
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // Responsive width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit
                        .cover, // Change to cover for better image display
                    height: 150, // Set a fixed height for the image
                    width: double.infinity, // Make image take full width
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Pilih jawaban yang benar:",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ), // Change text color
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ...options.map((option) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(option),
                      onTap: () async {
                        Navigator.of(context).pop(); // Close the dialog
                        if (option == correctAnswer) {
                          _showResultDialog(
                            "Jawaban benar! Anda mendapatkan 60 poin.",
                          );
                          setState(() {
                            playerSteps[player] =
                                (playerSteps[player] ?? 0) +
                                60; // Add 60 points
                            hasRolledDice = false; // Disable rolling again
                          });
                        } else {
                          _showResultDialog("Jawaban salah!");
                        }

                        // Move the player based on the current dice roll
                        await movePawnAlongPath(
                          player,
                          pawnIndex!, // Use the correct pawnIndex
                          currentDiceRoll,
                        );

                        setState(() {
                          currentPlayerTurn =
                              (currentPlayerTurn + 1) % 4; // Change player turn
                          hasRolledDice = false; // Reset dice status
                          currentDiceRoll = 0; // Reset dice
                        });
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<void> _showTimenDialog(Offset tilePosition, int player) async {
    final timeData = timeTiles[tilePosition];

    if (timeData != null) {
      int? pawnIndex;

      for (int i = 0; i < pawnPositions[player]!.length; i++) {
        if (pawnPositions[player]![i] == tilePosition) {
          pawnIndex = i;
          break;
        }
      }

      if (pawnIndex == null) return;

      String imagePath = timeData["image"];
      List<String> options;
      String correctAnswer;

      if (tilePosition == Offset(6, 3)) {
        options = ["A. Dada", "B. Mulut", "C. Tenggorokan", "D. Hidung"];
        correctAnswer = "D. Hidung";
      } else if (tilePosition == Offset(5, 8)) {
        options = [
          "A. Sebagai Otot Pernapasan Utama",
          "B. Sebagai Tempat Pencernaan Makanan",
          "C. Sebagai Tempat Pertukaran Oksigen",
          "D. Sebagai Otot Tenggorokan",
        ];
        correctAnswer = "A. Sebagai Otot Pernapasan Utama";
      } else if (tilePosition == Offset(11, 8)) {
        options = [
          "A. Saat Udara Keluar Dari Ukuran Diafragma Membesar",
          "B. Otot Diafragma Berkontraksi",
          "C. Rongga Perut Menurun",
          "D. Dada Merasa Sakit",
        ];
        correctAnswer = "B. Otot Diafragma Berkontraksi";
      } else if (tilePosition == Offset(12, 8)) {
        options = ["A. Paru-Paru", "B. Trakea", "C. Jantung", "D. Hidung"];
        correctAnswer = "B. Trakea";
      } else if (tilePosition == Offset(8, 4)) {
        options = ["A. Hidung", "B. Paru-paru", "C. Jantung", "D. Tenggorokan"];
        correctAnswer = "A. Hidung";
      } else {
        return; // Exit if no matching tile
      }

      int timeLeft = 30; // Total waktu dalam detik
      Timer? timer;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          timer = Timer.periodic(Duration(seconds: 1), (timer) {
            timeLeft--;
            if (timeLeft <= 0) {
              timer.cancel();
              Navigator.of(context).pop(); // Close dialog if time runs out
              // Move the pawn based on the dice value after time runs out
              movePawnAlongPath(player, pawnIndex!, currentDiceRoll);
              _showResultDialog("Waktu habis!");
              // Change player turn
              setState(() {
                currentPlayerTurn = (currentPlayerTurn + 1) % 4;
                hasRolledDice = false; // Reset dice status
                currentDiceRoll = 0; // Reset dice
              });
            }
          });

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              "Pertanyaan Keberuntungan (30 Detik)",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent, // Change title color
              ),
            ),
            content: SizedBox(
              width:
                  MediaQuery.of(context).size.width * 0.8, // Responsive width
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit
                          .cover, // Change to cover for better image display
                      height: 150, // Set a fixed height for the image
                      width: double.infinity, // Make image take full width
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...options.map((option) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(option),
                        onTap: () async {
                          timer
                              ?.cancel(); // Stop timer when an answer is selected
                          Navigator.of(context).pop(); // Close dialog
                          if (option == correctAnswer) {
                            _showResultDialog(
                              "Jawaban benar! Anda mendapatkan 40 poin.",
                            );
                            setState(() {
                              playerSteps[player] =
                                  (playerSteps[player] ?? 0) +
                                  40; // Add 40 points
                              hasRolledDice = false; // Disable rolling again
                            });
                          } else {
                            _showResultDialog("Jawaban salah!");
                          }

                          // Move the pawn based on the current dice roll
                          await movePawnAlongPath(
                            player,
                            pawnIndex!,
                            currentDiceRoll,
                          );

                          // Change player turn if dialog is closed
                          setState(() {
                            currentPlayerTurn =
                                (currentPlayerTurn + 1) %
                                4; // Change player turn
                            hasRolledDice = false; // Reset dice status
                            currentDiceRoll = 0; // Reset dice
                          });
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      );

      // Stop timer if dialog is closed
      timer?.cancel();
    }
  }

  bool _isAnyPawnOnTrack(int player) {
    return pawnPositions[player]!.any(
      (position) => !basePawns[player]!.any(
        (base) =>
            (position.dx - base.dx).abs() < 0.01 &&
            (position.dy - base.dy).abs() < 0.01,
      ),
    );
  }

  // Tambahkan print debug di movePawnAlongPath untuk melihat apakah move dipanggil dan posisi berubah
  Future<void> movePawnAlongPath(int player, int pawnIndex, int steps) async {
    if (steps <= 0) {
      print("Steps <= 0, skipping move");

      return;
    }

    print("Starting move for player $player, pawn $pawnIndex, steps $steps");
    final path = _getPlayerPath(player);
    int currentIndex = pawnPathIndex[player]![pawnIndex];
    print(
      "Current index: $currentIndex, current pos: ${pawnPositions[player]![pawnIndex]}",
    );

    final List<Offset> finishPositions = [
      Offset(6, 6), // Merah
      Offset(6, 8), // Hijau
      Offset(8, 8), // Kuning
      Offset(8, 6), // Biru
    ];

    int stepsToFinish = path.length - currentIndex - 1;

    if (currentIndex + steps > path.length - 1) {
      print("Over finish, stepsToFinish: $stepsToFinish");
      for (int i = 0; i < stepsToFinish; i++) {
        currentIndex++;
        pawnPositions[player]![pawnIndex] = path[currentIndex];
        print("Moving to index $currentIndex, pos ${path[currentIndex]}");
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 300));
        await AudioPlayer().play(AssetSource('sounds/move.mp3'));
      }

      int remainingSteps = (currentIndex + steps) - (path.length - 1);
      print("Remaining steps: $remainingSteps");
      for (int i = 0; i < remainingSteps; i++) {
        if (currentIndex > 0) {
          currentIndex--;
          pawnPositions[player]![pawnIndex] = path[currentIndex];
          print("Backing to index $currentIndex, pos ${path[currentIndex]}");
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 300));
          await AudioPlayer().play(AssetSource('sounds/move.mp3'));
        }
      }
    } else {
      print("Normal move");
      for (int i = 0; i < steps; i++) {
        if (currentIndex + 1 < path.length) {
          currentIndex++;
          pawnPositions[player]![pawnIndex] = path[currentIndex];
          print("Moving to index $currentIndex, pos ${path[currentIndex]}");
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 300));
          await AudioPlayer().play(AssetSource('sounds/move.mp3'));
        }
      }
    }

    pawnPathIndex[player]![pawnIndex] = currentIndex;
    print(
      "Final index: $currentIndex, final pos: ${pawnPositions[player]![pawnIndex]}",
    );

    // Cek apakah pion sudah sampai finish
    if (pawnPositions[player]![pawnIndex] == finishPositions[player]) {
      print("Reached finish for player $player");
      await onPieceFinished(_getColorName(player));
    }
  }

  Future<void> movePawnAnimated(int player, int pawnIndex, int steps) async {
    final audioPlayer = AudioPlayer();

    final Map<int, Offset> entryPoints = {
      0: Offset(6, 1), // Merah

      1: Offset(1, 8), // Hijau

      2: Offset(8, 13), // Kuning

      3: Offset(13, 6), // Biru
    };

    // If the pawn is still in base, move to entry point

    if (!_isInBase(player, pawnPositions[player]![pawnIndex])) {
      pawnPositions[player]![pawnIndex] = entryPoints[player]!;

      pawnPathIndex[player]![pawnIndex] = 0;

      setState(() {});

      await audioPlayer.play(AssetSource('sounds/move.mp3'));

      return;
    }

    // Get the player's path

    final path = _getPlayerPath(player);

    int currentIndex = pawnPathIndex[player]![pawnIndex];

    // Move the pawn according to the rolled steps

    for (int i = 0; i < steps; i++) {
      if (currentIndex + 1 < path.length) {
        currentIndex++;

        final newPos = path[currentIndex];

        // Remove the logic that returns a pawn to base

        positionOccupants[newPos] = player;

        pawnPositions[player]![pawnIndex] = newPos;

        pawnPathIndex[player]![pawnIndex] = currentIndex;

        setState(() {});

        await audioPlayer.play(AssetSource('sounds/move.mp3'));
      }
    }
  }

  void _handlePawnTap(int player, int pawnIndex) async {
    print(
      "Handling tap for player $player, pawn $pawnIndex, currentPlayerTurn $currentPlayerTurn, dice $currentDiceRoll, isInBase ${_isInBase(player, pawnPositions[player]![pawnIndex])}",
    );

    if (isGameOver) {
      _showResultDialogWinner(
        "Permainan sudah selesai.",
        winner: winnerName,
        points: playerPoints[winnerName] ?? 0,
      );
      return;
    }
    if (currentPlayerTurn != player) return;

    // Check if the player has finished all pawns

    if (playerPiecesFinished[player] == 4) {
      _showResultDialog("Anda sudah menyelesaikan permainan!");
      return; // Prevent further interaction with this player
    }

    if (currentDiceRoll == 0) {
      _showResultDialog("Silakan lempar dadu terlebih dahulu!");
      return;
    }

    final currentPos = pawnPositions[player]![pawnIndex];

    // Check if the pawn has reached the finish position
    final finishPositions = [
      Offset(6, 6), // Merah
      Offset(6, 8), // Hijau
      Offset(8, 8), // Kuning
      Offset(8, 6), // Biru
    ];

    if (currentPos == finishPositions[player]) {
      _showResultDialog(
        "Pion sudah sampai finish dan tidak dapat disentuh lagi.",
      );
      return; // Prevent further interaction with this pawn
    }

    final bool isInBase = _isInBase(player, currentPos);

    // Allow the player to move if they rolled a 6
    if (currentDiceRoll == 6 && isInBase) {
      await _movePawnFromBase(player, pawnIndex);
      return;
    }

    // Reset status dadu agar tombol berubah ke "Roll Dadu"

    // setState(() {
    //   hasRolledDice = false;

    //   currentDiceRoll = 0;

    //   // Giliran tetap sama, jadi tidak ganti currentPlayerTurn
    // });

    // Check if the player has already moved two pawns out of the base
    int pawnsOutOfBase = pawnPositions[player]!
        .where((pos) => !_isInBase(player, pos))
        .length;

    if (isInBase && pawnsOutOfBase >= 2) {
      _showResultDialog(
        "Anda sudah mengeluarkan 2 pion, perlu angka 6 untuk mengeluarkan pion ketiga.",
      );
      return;
    }

    if (!isInBase) {
      // Check if the current position is a lucky tile
      if (luckyTiles.containsKey(currentPos)) {
        // Show the question dialog
        await _showQuestionDialog(currentPos, player);
      } else if (quizTiles.containsKey(currentPos)) {
        // Show the question dialog
        await _showQuiznDialog(currentPos, player);
      } else if (timeTiles.containsKey(currentPos)) {
        // Show the question dialog
        await _showTimenDialog(currentPos, player);
      } else if (materialTiles.containsKey(currentPos)) {
        // Show material dialog
        await _showMaterialDialog(currentPos, player, pawnIndex);
      } else {
        // Move the pawn normally
        await movePawnAlongPath(player, pawnIndex, currentDiceRoll);
        setState(() {
          currentDiceRoll = 0;
          hasRolledDice = false;
          currentPlayerTurn = (currentPlayerTurn + 1) % 4;
        });
      }
    } else {
      _showResultDialog("Pion masih di base, perlu angka 6 untuk keluar");
    }

    // Check if the player has any pawns that can be moved
    if (!hasPawnsOnTrack) {
      // Skip to the next player
      setState(() {
        currentPlayerTurn = (currentPlayerTurn + 1) % 4;
        currentDiceRoll = 0; // Reset dice
        hasRolledDice = false; // Allow next player to roll
      });
    }
  }

  Future<void> onPieceFinished(String player) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Pion finish untuk pemain $player"),
        duration: Duration(seconds: 2),
      ),
    );

    setState(() {
      playerPiecesFinished[player] = playerPiecesFinished[player]! + 1;
      playerPoints[player] = playerPoints[player]! + 10;
    });

    if (playerPiecesFinished[player] == 4) {
      setState(() {
        isGameOver = true;
        winnerName = player;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Pemain $player menang!"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(Duration(milliseconds: 300));
      await showWinnerDialog(player, playerPoints[player]!);
    }
  }

  List<Widget> _buildPawns(int row, int col) {
    Map<int, List<int>> playersWithPawns = {};

    // Collect all pawns at this position
    pawnPositions.forEach((player, positions) {
      List<int> pawnIndices = [];

      for (int i = 0; i < positions.length; i++) {
        if (positions[i].dx == row && positions[i].dy == col) {
          pawnIndices.add(i);
        }
      }

      if (pawnIndices.isNotEmpty) {
        playersWithPawns[player] = pawnIndices;
      }
    });

    // If no pawns, return empty widget
    if (playersWithPawns.isEmpty) {
      return [];
    }

    // Hitung total pion di posisi ini
    int totalPawns = playersWithPawns.values.fold(
      0,
      (sum, list) => sum + list.length,
    );

    // Jika lebih dari 1 pion, tampilkan pion warna ungu
    if (totalPawns > 1) {
      return [
        GestureDetector(
          onTap: () {
            _showPawnSelectionDialog(row, col);
          },
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            child: Transform.translate(
              offset: Offset(0, -6), // Geser 6 pixel ke atas
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.7),
                      Colors.purple.withOpacity(0.9),
                      Colors.purple,
                    ],
                    center: Alignment.topLeft,
                    radius: 0.9,
                  ),
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 3,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ];
    }

    // Jika hanya 1 pion, tampilkan pion dengan warna pemain
    return [
      GestureDetector(
        onTap: () {
          // Check if the tapped position corresponds to a material tile
          if (materialTiles.containsKey(
            Offset(row.toDouble(), col.toDouble()),
          )) {
            if (playersWithPawns.length > 1) {
              _showPawnSelectionDialog(row, col);
            } else {
              final player = playersWithPawns.keys.first;
              final pawnIndex = playersWithPawns[player]!.first;
              _handlePawnTap(player, pawnIndex);
            }
          } else {
            if (playersWithPawns.length > 1) {
              _showPawnSelectionDialog(row, col);
            } else {
              final player = playersWithPawns.keys.first;
              final pawnIndex = playersWithPawns[player]!.first;
              _handlePawnTap(player, pawnIndex);
            }
          }
        },
        child: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          child: Stack(
            children: playersWithPawns.entries.expand((playerEntry) {
              int player = playerEntry.key;
              return playerEntry.value.map((pawnIndex) {
                return Align(
                  alignment: Alignment.center,
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      final double scale = 0.9 + (value * 0.05); // kecil, halus
                      final double glow = value * 2; // glow kecil

                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.4),
                                blurRadius: glow, // glow kecil & lembut
                                spreadRadius: glow * 0.3,
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset(
                              _getPawnImage(player),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }).toList();
            }).toList(),
          ),
        ),
      ),
    ];
  }

  // Tambahkan fungsi helper untuk mendapatkan path gambar pion

  String _getPawnImage(int player) {
    switch (player) {
      case 0: // Merah

        return 'assets/images/pion/Hidung.png';

      case 1: // Hijau

        return 'assets/images/pion/Trakea.png';

      case 2: // Kuning

        return 'assets/images/pion/Faring.png';

      case 3: // Biru

        return 'assets/images/pion/Paru-paru.png';

      default:
        return 'assets/images/pion/Hidung.png'; // Default
    }
  }

  Future<void> _showPawnSelectionDialog(int row, int col) async {
    // Collect all pawns in this box
    List<MapEntry<int, int>> availablePawns = [];
    pawnPositions.forEach((player, positions) {
      for (int i = 0; i < positions.length; i++) {
        if (positions[i].dx == row && positions[i].dy == col) {
          availablePawns.add(MapEntry(player, i));
        }
      }
    });

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Pilih Pion"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: availablePawns.map((entry) {
            return ListTile(
              leading: _buildPawnWidget(entry.key),
              title: Text("Pion ${_getColorName(entry.key)}"),
              onTap: () {
                Navigator.pop(context);
                _handlePawnTap(entry.key, entry.value);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getColorName(int player) {
    switch (player) {
      case 0:
        return "Merah";
      case 1:
        return "Hijau";
      case 2:
        return "Kuning";
      case 3:
        return "Biru";
      default:
        return "";
    }
  }

  Widget _buildPawnWidget(int player) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipOval(
        child: Image.asset(_getPawnImage(player), fit: BoxFit.cover),
      ),
    );
  }

  Future<void> movePawnFromBase(int player, int pawnIndex) async {
    final audioPlayer = AudioPlayer();

    final Map<int, Offset> entryPoints = {
      0: Offset(6, 1), // merah
      1: Offset(1, 8), // hijau
      2: Offset(8, 13), // kuning
      3: Offset(13, 6), // biru
    };

    // Set posisi ke titik masuk
    pawnPositions[player]![pawnIndex] = entryPoints[player]!;
    pawnPathIndex[player]![pawnIndex] = 0;

    // Mainkan suara keluar base
    await audioPlayer.play(AssetSource('sounds/move.mp3'));

    setState(() {});
  }

  Future<void> _movePawnFromBase(int player, int pawnIndex) async {
    final entryPoints = {
      0: Offset(6, 1), // Merah
      1: Offset(1, 8), // Hijau
      2: Offset(8, 13), // Kuning
      3: Offset(13, 6), // Biru
    };

    // Set posisi pion ke titik masuk
    pawnPositions[player]![pawnIndex] = entryPoints[player]!;
    pawnPathIndex[player]![pawnIndex] = 0;

    setState(() {});
    await AudioPlayer().play(AssetSource('sounds/move.mp3'));

    // Ganti giliran dan reset status dadu

    setState(() {
      currentPlayerTurn = (currentPlayerTurn + 1) % 4;

      hasRolledDice = false;

      currentDiceRoll = 0;
    });
  }

  void _showResultDialog(String message) {
    // Memutar suara alert sebelum menampilkan dialog
    final audioPlayer = AudioPlayer();
    audioPlayer.play(AssetSource('sounds/alert.mp3'));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        insetAnimationDuration: const Duration(milliseconds: 300),
        insetAnimationCurve: Curves.easeOutBack,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _playerColor(currentPlayerTurn).withOpacity(0.2),
                _playerColor(currentPlayerTurn).withOpacity(0.4),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ikon animasi
              RotationTransition(
                turns: Tween(begin: 0.0, end: 0.1).animate(
                  CurvedAnimation(
                    parent: ModalRoute.of(context)!.animation!,
                    curve: Curves.elasticOut,
                  ),
                ),
                child: Icon(
                  Icons.warning_rounded,
                  size: 60,
                  color: _playerColor(currentPlayerTurn),
                ),
              ),

              const SizedBox(height: 20),

              // Teks pesan
              Text(
                "Perhatian!",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
              ),

              const SizedBox(height: 25),

              // Tombol
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _playerColor(currentPlayerTurn),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
                child: Text(
                  "Mengerti",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _playerColor(int player) {
    switch (player) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.green;
      case 2:
        return Colors.amber[800]!;
      case 3:
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  bool _isTrackCell(int row, int col) {
    return ludoPath.contains(Offset(row.toDouble(), col.toDouble())) ||
        (col == 6 && row > 0 && row < 6) || // jalur merah (atas ke tengah)
        (row == 6 && col > 8 && col < 14) || // jalur hijau (kanan ke tengah)
        (col == 8 && row > 8 && row < 14) || // jalur kuning (bawah ke tengah)
        (row == 8 && col > 0 && col < 6) || // jalur biru (kiri ke tengah)
        (col == 8 &&
            row > 0 &&
            row < 6) || // jalur kuning (tengah ke base kuning)
        (row == 8 && col > 8 && col < 14); //  jalur kuning (kanan ke tengah)
  }

  Color _playerColorFromPosition(int row, int col) {
    if (row == 6 && col == 6) return Colors.red;
    if (row == 6 && col == 8) return Colors.green;
    if (row == 8 && col == 6) return Colors.blue;
    if (row == 8 && col == 8) return Colors.yellow;
    return Colors.grey.shade300;
  }

  Color _getCellColor(int row, int col) {
    if (row < 6 && col < 6) return Colors.red;
    if (row < 6 && col > 8) return Colors.green;
    if (row > 8 && col > 8) return Colors.yellow;
    if (row > 8 && col < 6) return Colors.blue;

    // Kotak keluar base (masuk ke jalur utama)
    if (row == 6 && col == 1) return Colors.red; // MERAH
    if (row == 1 && col == 8) return Colors.green; // HIJAU
    if (row == 8 && col == 13) return Colors.yellow; // KUNING
    if (row == 13 && col == 6) return Colors.blue; // BIRU

    // Jalur Hijau di tengah atas (dari baris 1 sampai 5, kolom 7)
    if (col == 7 && row >= 1 && row <= 5) return Colors.green;
    // Jalur Kuning di tengah kanan (dari kolom 9 sampai 13, baris 7)
    if (row == 7 && col >= 9 && col <= 13) return Colors.yellow;
    // Jalur Biru di tengah bawah (dari baris 9 sampai 13, kolom 7)
    if (col == 7 && row >= 9 && row <= 13) return Colors.blue;
    // Jalur Merah di tengah kiri (dari kolom 1 sampai 5, baris 7)
    if (row == 7 && col >= 1 && col <= 5) return Colors.red;
    if ((row == 6 && col == 6) ||
        (row == 6 && col == 8) ||
        (row == 8 && col == 6) ||
        (row == 8 && col == 8)) {
      return _playerColorFromPosition(row, col).withOpacity(0.8);
    }
    if ((row == 6 || row == 7 || row == 8) &&
        (col == 6 || col == 7 || col == 8)) {
      if (row == 6 && col == 6) return Colors.red;
      if (row == 6 && col == 8) return Colors.green;
      if (row == 8 && col == 6) return Colors.blue;
      if (row == 8 && col == 8) return Colors.yellow;
      return Colors.grey.shade300;
    }
    if ((row == 6 || row == 8) || (col == 6 || col == 8)) {
      return Colors.white;
    }
    return Colors.grey[100]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // penting agar AppBar menyatu
      backgroundColor: Colors.transparent, // biar transparan
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.teal.withOpacity(0.9),
                Colors.cyan.withOpacity(0.75),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.sports_esports,
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'LUNAS',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '(Ludo Sistem Pernapasan)',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 48,
                ), // spacer untuk sejajar dengan ikon kembali
              ],
            ),
          ),
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.1), // Gambar jadi lebih transparan
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 10),

                Column(
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: currentDiceRoll > 0
                            ? Image.asset(
                                'assets/images/dice/dice_$currentDiceRoll.png',
                                key: ValueKey(currentDiceRoll),
                              )
                            : const SizedBox(), // tetap jaga ukuran, hanya kosong
                      ),
                    ),
                    const SizedBox(height: 12),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _playerColor(
                          currentPlayerTurn,
                        ).withOpacity(0.9),
                        shadowColor: Colors.black45,
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                      ),
                      onPressed: () async {
                        if (isGameOver) {
                          _showResultDialogWinner(
                            "Permainan sudah selesai.",
                            winner: winnerName,
                            points: playerPoints[winnerName] ?? 0,
                          );
                          return;
                        }

                        if ((hasRolledDice && hasPawnsOnTrack) ||
                            currentDiceRoll == 6) {
                          _showResultDialog(
                            "Silakan gerakkan pion Anda terlebih dahulu",
                          );
                          return;
                        }

                        final audioPlayer = AudioPlayer();
                        await audioPlayer.play(AssetSource('sounds/roll.mp3'));

                        // int dice = 6;
                        int dice =
                            1 + (DateTime.now().millisecondsSinceEpoch % 6);

                        setState(() {
                          currentDiceRoll = dice;
                          hasRolledDice =
                              true; // Set rolled dice to true after rolling
                        });

                        await Future.delayed(const Duration(milliseconds: 500));

                        // Define the finish position for each player
                        final List<Offset> finishPositions = [
                          Offset(6, 6), // Merah
                          Offset(6, 8), // Hijau
                          Offset(8, 8), // Kuning
                          Offset(8, 6), // Biru
                        ];

                        // Hitung kondisi khusus
                        int finished = pawnPositions[currentPlayerTurn]!
                            .where(
                              (pos) =>
                                  finishPositions[currentPlayerTurn] == pos,
                            )
                            .length;
                        int inBase = pawnPositions[currentPlayerTurn]!
                            .where((pos) => _isInBase(currentPlayerTurn, pos))
                            .length;
                        bool specialCaseOne =
                            finished == 1 && inBase == 3 && dice != 6;

                        bool specialCaseTwo =
                            finished == 2 && inBase == 2 && dice != 6;

                        bool specialCaseThree =
                            finished == 3 && inBase == 1 && dice != 6;
                        bool specialCaseFour = finished == 4 && inBase == 0;
                        // Hanya tampilkan notifikasi jika dadu menunjukkan angka 6
                        if (specialCaseFour) {
                          // Game over

                          setState(() {
                            isGameOver = true;

                            winnerName = _getColorName(currentPlayerTurn);
                          });

                          await Future.delayed(Duration(milliseconds: 500));

                          final AudioPlayer audioPlayer = AudioPlayer();

                          await audioPlayer.play(AssetSource('sounds/win.mp3'));

                          // Di dalam bagian specialCaseFour, ubah dialog sebagai berikut:

                          await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                elevation: 16,
                                backgroundColor: Colors.white,
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.orange.shade200,
                                        Colors.deepOrange.shade400,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.deepOrange.withOpacity(
                                          0.5,
                                        ),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.emoji_events_rounded,
                                        size: 72,
                                        color: Colors.yellow.shade700,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10,
                                            color: Colors.black26,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Permainan Berakhir!',
                                        textAlign: TextAlign
                                            .center, // Tambahkan ini untuk memusatkan teks
                                        style: GoogleFonts.poppins(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 6,
                                              color: Colors.black38,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Pemain $winnerName telah memenangkan permainan!',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Poin Akhir:',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ...playerPoints.entries
                                          .map(
                                            (entry) => Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 4,
                                                  ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: _playerColorByName(
                                                  entry.key,
                                                ), // Background warna pemain
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                '${entry.key}: ${entry.value}',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color: Colors
                                                      .white, // Warna teks putih untuk kontras
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      const SizedBox(height: 24),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.yellow.shade700,
                                          foregroundColor:
                                              Colors.deepOrange.shade900,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 36,
                                            vertical: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          elevation: 8,
                                          shadowColor: Colors.black45,
                                        ),
                                        onPressed: () {
                                          Navigator.of(
                                            context,
                                          ).popUntil((route) => route.isFirst);
                                        },
                                        child: Text(
                                          'OK',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          return;
                        } else if (specialCaseOne ||
                            specialCaseTwo ||
                            specialCaseThree) {
                          // Gabungkan specialCaseOne, Two, Three: Langsung ganti pemain tanpa notifikasi

                          await Future.delayed(Duration(milliseconds: 500));

                          setState(() {
                            currentPlayerTurn = (currentPlayerTurn + 1) % 4;

                            currentDiceRoll = 0; // Reset dice

                            hasRolledDice = false; // Allow next player to roll
                          });
                        } else if (dice == 6) {
                          // Baru cek dice == 6 jika specialCase tidak terpenuhi

                          final playerColor = _playerColor(currentPlayerTurn);

                          await showDialog(
                            context: context,

                            builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),

                              elevation: 8,

                              child: Container(
                                padding: EdgeInsets.all(20),

                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,

                                    end: Alignment.bottomRight,

                                    colors: [
                                      playerColor.withOpacity(0.1),

                                      playerColor.withOpacity(0.3),
                                    ],
                                  ),

                                  borderRadius: BorderRadius.circular(20),
                                ),

                                child: Column(
                                  mainAxisSize: MainAxisSize.min,

                                  children: [
                                    Icon(
                                      Icons.star_rate_rounded,

                                      size: 40,

                                      color: playerColor,
                                    ),

                                    SizedBox(height: 16),

                                    Text(
                                      "Pemain ${currentPlayerTurn + 1}",

                                      style: GoogleFonts.poppins(
                                        fontSize: 20,

                                        fontWeight: FontWeight.bold,

                                        color: playerColor,
                                      ),
                                    ),

                                    SizedBox(height: 8),

                                    Text(
                                      "Mendapat angka $dice!",

                                      style: GoogleFonts.poppins(
                                        fontSize: 18,

                                        color: Colors.black87,
                                      ),
                                    ),

                                    SizedBox(height: 16),

                                    Text(
                                      "Silakan pilih pion untuk digerakkan",

                                      textAlign: TextAlign.center,

                                      style: GoogleFonts.poppins(
                                        fontSize: 16,

                                        color: Colors.black54,
                                      ),
                                    ),

                                    SizedBox(height: 24),

                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: playerColor,

                                        foregroundColor: Colors.white,

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),

                                        padding: EdgeInsets.symmetric(
                                          horizontal: 24,

                                          vertical: 12,
                                        ),

                                        elevation: 3,
                                      ),

                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },

                                      child: Text(
                                        "Mengerti",

                                        style: GoogleFonts.poppins(
                                          fontSize: 16,

                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (_isAnyPawnOnTrack(currentPlayerTurn)) {
                          // Allow the player to choose a pawn to move
                          // After moving the pawn, reset the dice and change player
                          // Example: After moving the pawn, you can call:
                          // setState(() {
                          //   currentDiceRoll = 0; // Reset dice
                          //   hasRolledDice = false; // Allow next player to roll
                          //   currentPlayerTurn = (currentPlayerTurn + 1) % 4; // Change player
                          // });
                        } else {
                          // Ganti pemain
                          await Future.delayed(const Duration(seconds: 1));
                          setState(() {
                            currentDiceRoll = 0; // Reset dice
                            currentPlayerTurn =
                                (currentPlayerTurn + 1) % 4; // Change player
                            hasRolledDice = false; // Allow next player to roll
                          });
                        }
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          hasRolledDice
                              ? (canMovePawn ? "Gerakkan Pion" : "Lempar Lagi")
                              : "Roll Dadu",
                          key: ValueKey('${hasRolledDice}_${canMovePawn}'),
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Align to start for better use of space
                    children: List.generate(
                      4,
                      (index) => Container(
                        constraints: BoxConstraints(
                          minWidth:
                              MediaQuery.of(context).size.width *
                              0.2, // 20% of screen width
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 2, // Reduced horizontal margin
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 4, // Reduced horizontal padding
                          vertical: 6, // Reduced vertical padding
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // Slightly smaller radius
                          border: Border.all(
                            color: _playerColor(index).withOpacity(0.8),
                            width: currentPlayerTurn == index
                                ? 2
                                : 1, // Slightly thinner border
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _playerColor(index).withOpacity(0.25),
                              blurRadius: 4, // Reduced blur radius
                              offset: Offset(0, 2), // Reduced offset
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 20,

                              height: 20,

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                border: Border.all(
                                  color: Colors.white,

                                  width: 1.5,
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),

                                    blurRadius: 4,

                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),

                              child: ClipOval(
                                child: Image.asset(
                                  _getPawnImage(index),

                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 4), // Reduced space
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: _playerColor(index),
                                  size: 14, // Reduced icon size
                                ),
                                SizedBox(width: 2), // Reduced space
                                Flexible(
                                  child: Text(
                                    "Poin: ${playerSteps[index]}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 10, // Reduced font size
                                      color: _playerColor(index),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              _isAnyPawnOnTrack(index) ? "Di Jalur" : "Di Base",
                              style: GoogleFonts.poppins(
                                fontSize: 8, // Reduced font size
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ), //Table Papan
                const SizedBox(height: 10),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Ambil ukuran sisi terkecil (lebar atau tinggi)
                        final boardSize = constraints.biggest.shortestSide;

                        return Center(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.orange.shade100.withOpacity(0.85),
                                    Colors.brown.shade300.withOpacity(0.95),
                                  ],
                                  center: Alignment.center,
                                  radius: 1.2,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(95, 0, 0, 0),
                                    blurRadius: 14,
                                    offset: Offset(4, 6),
                                  ),
                                  BoxShadow(
                                    color: Color.fromARGB(60, 255, 255, 255),
                                    blurRadius: 12,
                                    spreadRadius: -4,
                                    offset: Offset(-4, -4),
                                  ),
                                ],
                              ),
                              child: GridView.builder(
                                padding: const EdgeInsets.all(2),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: gridSize * gridSize,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 15,
                                    ),

                                // Di dalam itemBuilder dari GridView.builder, ubah sebagai berikut:
                                itemBuilder: (context, index) {
                                  final row = index ~/ gridSize;
                                  final col = index % gridSize;
                                  final cellColor = _getCellColor(row, col);
                                  final pawns = _buildPawns(row, col);
                                  final isTrack = _isTrackCell(row, col);

                                  // Cek apakah ada ikon untuk ditampilkan
                                  Widget? iconWidget;
                                  final screenWidth = MediaQuery.of(
                                    context,
                                  ).size.width;
                                  bool isSmallScreen =
                                      screenWidth < 600; // HP threshold

                                  // icon kecil, soft glow, tetap center, offset tipis
                                  Widget makeCuteIcon(
                                    IconData icon,
                                    Color color, {
                                    Offset offset = Offset.zero,
                                  }) {
                                    final appliedOffset = isSmallScreen
                                        ? Offset.zero
                                        : offset;

                                    double iconSize = isSmallScreen
                                        ? 10
                                        : 13; // lebih kecil di HP
                                    double paddingSize = isSmallScreen
                                        ? 1.2
                                        : 2; // padding juga kecil di HP
                                    double blur = isSmallScreen
                                        ? 1
                                        : 2; // shadow kecil di HP

                                    return Align(
                                      alignment: Alignment.center,
                                      child: Transform.translate(
                                        offset: appliedOffset,
                                        child: Container(
                                          padding: EdgeInsets.all(paddingSize),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: color.withOpacity(0.18),
                                            boxShadow: [
                                              BoxShadow(
                                                color: isSmallScreen
                                                    ? Colors
                                                          .transparent // HP: tanpa shadow
                                                    : color.withOpacity(
                                                        0.30,
                                                      ), // Desktop: soft glow
                                                blurRadius: blur,
                                                spreadRadius: 0.4,
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            icon,
                                            color: color,
                                            size: iconSize,
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  // offset kecil biar "hidup", tapi tetap center
                                  if (materialTiles.containsKey(
                                    Offset(row.toDouble(), col.toDouble()),
                                  )) {
                                    iconWidget = makeCuteIcon(
                                      Icons.backpack,
                                      Colors.orange,
                                      offset: const Offset(0, -1), // dikit atas
                                    );
                                  } else if (luckyTiles.containsKey(
                                    Offset(row.toDouble(), col.toDouble()),
                                  )) {
                                    iconWidget = makeCuteIcon(
                                      Icons.star_rounded,
                                      Colors.yellow,
                                      offset: const Offset(1, 0), // dikit kanan
                                    );
                                  } else if (quizTiles.containsKey(
                                    Offset(row.toDouble(), col.toDouble()),
                                  )) {
                                    iconWidget = makeCuteIcon(
                                      Icons.question_mark,
                                      Colors.blueAccent,
                                      offset: const Offset(-1, 0), // dikit kiri
                                    );
                                  } else if (timeTiles.containsKey(
                                    Offset(row.toDouble(), col.toDouble()),
                                  )) {
                                    iconWidget = makeCuteIcon(
                                      Icons.hourglass_bottom,
                                      Colors.green,
                                      offset: const Offset(0, 1), // dikit bawah
                                    );
                                  }

                                  return Container(
                                    decoration: BoxDecoration(
                                      color:
                                          cellColor, // warna solid tanpa efek gradient
                                      border: Border.all(
                                        color: Colors
                                            .black, // warna border standar
                                        width:
                                            0.3, // bisa sesuaikan jika ingin lebih tebal
                                      ),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Ikon untuk tile khusus (di bawah pawns)
                                        if (iconWidget != null) iconWidget,
                                        // Pawns (di atas ikon)
                                        if (pawns.isNotEmpty) ...pawns,
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
