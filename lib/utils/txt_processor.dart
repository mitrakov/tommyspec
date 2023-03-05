import 'package:csv/csv.dart';

class TextProcessor {
  static final _csvRegex = RegExp("csv (\\d+) (\\d+)");
  static final _rowRegex = RegExp("row (\\d+)");
  static final _wordRegex = RegExp("word (\\d+)");
  static final _wordsRegex = RegExp("words (\\d+)-(\\d+)");
  static final _separatorRegex = RegExp("sep (.)");
  static final _error = Exception("""Invalid command. Try "text", "csv 1 1", "csv 1 1 sep ;", "row 1", "row 1 word 1", "row 1 words 1-3", "row 1 word 1 sep |".""");

  static String process(String cmd, String input) {
    final s = input.replaceAll('\r\n', '\n');
    if (cmd == "text") return s;

    // parsing cmd
    final row = _rowRegex.firstMatch(cmd)?.group(1);
    final word = _wordRegex.firstMatch(cmd)?.group(1);
    final wordsFrom = _wordsRegex.firstMatch(cmd)?.group(1);
    final wordsTo = _wordsRegex.firstMatch(cmd)?.group(2);
    final csvRow = _csvRegex.firstMatch(cmd)?.group(1);
    final csvCol = _csvRegex.firstMatch(cmd)?.group(2);
    final separator = _separatorRegex.firstMatch(cmd)?.group(1);

    // checks
    final bool rowCmdExists = row != null;
    final bool wordCmdExists = word != null || wordsTo != null;
    final bool csvCmdExists = csvRow != null && csvCol != null;
    if (!rowCmdExists && !wordCmdExists && !csvCmdExists) throw _error;

    // parsing rows and words
    int rowNumber = 0;
    int wordFromNumber = 0;
    int wordToNumber = 0;
    int csvRowNumber = 0;
    int csvColNumber = 0;
    if (rowCmdExists) {
      rowNumber = int.parse(row) - 1;                      // 1-based to 0-based
    }
    if (csvCmdExists) {
      csvRowNumber = int.parse(csvRow) - 1;                // 1-based to 0-based
      csvColNumber = int.parse(csvCol) - 1;                // 1-based to 0-based
    }
    if (wordsFrom != null && wordsTo != null) {
      wordFromNumber = int.parse(wordsFrom) - 1;           // 1-based to 0-based
      wordToNumber = int.parse(wordsTo) - 1;               // 1-based to 0-based
    } else if (word != null) {
      wordFromNumber = wordToNumber = int.parse(word) - 1; // 1-based to 0-based
    }

    // processing csv
    if (csvCmdExists) {
      final List<List> table = CsvToListConverter(eol: '\n', fieldDelimiter: separator).convert(s);
      final cell = table[csvRowNumber][csvColNumber];
      return cell.toString();
    } else {
      // processing text
      final delimiter = separator ?? " ";
      final List<String> lines = s.split('\n');
      if (!wordCmdExists) return lines[rowNumber];
      final List<List<String>> words = lines.map((l) => l.split(delimiter).where((w) => w.isNotEmpty).toList()).toList(); // make 2-dimension array of words
      final List<String> line = rowCmdExists ? words[rowNumber] : words.expand((l) => l).toList();                        // make 1-dimension array of words
      final List<String> range = line.getRange(wordFromNumber, wordToNumber + 1).toList();                                // get range of words
      return range.join(delimiter); // mkString words
    }
  }
}
