class TextProcessor {
  static final _csvRegex = RegExp(".*csv (\\d+) (\\d+).*");
  static final _rowRegex = RegExp(".*row (\\d+).*");
  static final _wordRegex = RegExp(".*word (\\d+).*");
  static final _wordsRegex = RegExp(".*words (\\d+)-(\\d+).*");
  static final _separatorRegex = RegExp(".*sep (.).*");
  static final error = Exception("""Invalid command. Try "text", "csv", "row 1", "row 1 word 1", "row 1 words 1-3", "row 1 word 1 sep |".""");

  static String process(String cmd, String s) {
    // parsing cmd
    final row = _rowRegex.firstMatch(cmd)?.group(1);
    final word = _wordRegex.firstMatch(cmd)?.group(1);
    final wordsFrom = _wordsRegex.firstMatch(cmd)?.group(1);
    final wordsTo = _wordsRegex.firstMatch(cmd)?.group(2);
    final csvFrom = _csvRegex.firstMatch(cmd)?.group(1);
    final csvTo = _csvRegex.firstMatch(cmd)?.group(2);
    final separator = _separatorRegex.firstMatch(cmd)?.group(1) ?? " ";

    // text vs csv vs row-word
    if (cmd.contains("text")) return s;
    if (csvFrom != null && csvTo != null) return "TODO csv";
    if (row == null && word == null && wordsFrom == null && wordsTo == null) throw error;

    // row-word processing
    int rowNumber = 0;
    int wordFromNumber = 0;
    int wordToNumber = 0;

    // checking "row" clause
    if (row != null) {
      rowNumber = int.parse(row) - 1;                      // 1-based to 0-based
    }
    // checking "word" or "words" clause
    if (wordsFrom != null && wordsTo != null) {
      wordFromNumber = int.parse(wordsFrom) - 1;           // 1-based to 0-based
      wordToNumber = int.parse(wordsTo) - 1;               // 1-based to 0-based
    } else if (word != null) {
      wordFromNumber = wordToNumber = int.parse(word) - 1; // 1-based to 0-based
    }

    // processing
    final bool rowCmdExists = (row != null);
    final bool wordCmdExists = (word != null || wordsFrom != null);
    final List<String> lines = s.split("\n");
    if (!wordCmdExists) return lines[rowNumber];
    final List<List<String>> words = lines.map((l) => l.split(separator).where((w) => w.isNotEmpty).toList()).toList(); // make 2-dimension array of words
    final List<String> line = rowCmdExists ? words[rowNumber] : words.expand((l) => l).toList();                        // make 1-dimension array of words
    final List<String> range = line.getRange(wordFromNumber, wordToNumber + 1).toList();                                // get range of words
    return range.join(separator);                                                                                       // mkString words
  }
}
