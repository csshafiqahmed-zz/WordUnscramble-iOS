import UIKit

public class UnScrambler {

    private static var unscrambler: UnScrambler!

    public private(set) var allWords = Set<String>()
    public private(set) var wordsWithDefinitions = Set<String>()
    public private(set) var wordsWithoutDefinitions = Set<String>()
    public private(set) var scrabbleCharacterPointsArray = [Character: Int]()
    public private(set) var sortedWordsDictionary = [String: [String]]()

    private init() {
        loadWordsFromFile()
        setupScrabbleCharacterPointsArray()
        parseWordsToDictionary()
    }

    public static func getInstance() -> UnScrambler {
        if unscrambler == nil {
            unscrambler = UnScrambler()
        }
        return unscrambler
    }

    private func loadWordsFromFile() {
        guard let allWordsUrl = Bundle.main.url(forResource: Default.WORDS_FILE_NAME, withExtension: ".txt"),
                let wordsWithDefinitionsUrl = Bundle.main.url(forResource: Default.WORDS_WITH_DEFINITIONS, withExtension: ".txt"),
                let wordsWithoutDefinitionsUrl = Bundle.main.url(forResource: Default.WORDS_WITHOUT_DEFINITIONS, withExtension: ".txt") else { return }

        do {
            let allWordFileContents = try String(contentsOf: allWordsUrl)
            self.allWords = Set(allWordFileContents.components(separatedBy: "\n"))

            let wordsWithDefinitionsFileContents = try String(contentsOf: wordsWithDefinitionsUrl)
            self.wordsWithDefinitions = Set(wordsWithDefinitionsFileContents.components(separatedBy: "\n"))

            let wordsWithoutDefinitionsFileContents = try String(contentsOf: wordsWithoutDefinitionsUrl)
            self.wordsWithoutDefinitions = Set(wordsWithoutDefinitionsFileContents.components(separatedBy: "\n"))
        } catch {
            // TODO Log event
            print("Failed to load files")
        }
    }

    private func setupScrabbleCharacterPointsArray() {
        let alphabetString = "abcdefghijklmnopqrstuvwxyz"
        var valueDict = [Int: [Character]]()
        valueDict[2] = ["l", "s", "u", "n", "r", "t", "o", "a", "i", "e"]
        valueDict[3] = ["g", "d"]
        valueDict[4] = ["f", "h", "v", "w", "y"]
        valueDict[5] = ["k"]
        valueDict[8] = ["j", "k"]
        valueDict[10] = ["q", "z"]

        alphabetString.forEach { letter in
            var points = 0
            for (key, value) in valueDict where value.contains(letter) {
                points = key
            }

            self.scrabbleCharacterPointsArray[letter] = points
        }
    }

    private func parseWordsToDictionary() {
        DispatchQueue.main.async {
            self.allWords.forEach { word in
                let sortedWord = String(word.sorted())

                if self.sortedWordsDictionary.keys.contains(sortedWord) {
                    self.sortedWordsDictionary[sortedWord]?.append(word)
                } else {
                    self.sortedWordsDictionary[sortedWord] = [word]
                }
            }
        }
    }

    public func unscrambleWord(_ unscrambledWord: String) -> [Section] {
        let staredWordsController = StaredWordsController.getInstance()
        var scrambledWords = [Section]()
        let sortedWord = String(cleanWord(unscrambledWord).sorted())
        // Iterate from 2 -> Length of unscrambledWord
        for i in stride(from: 2, through: unscrambledWord.count+1, by: 1) {
            // All possible combinations of words with length i
            let wordCombinations = Combinatorics.combinationsWithoutRepetitionFrom(Array(sortedWord), taking: i)
            var words = [Word]()
            // Iterate through all of the combinations of words
            for w in wordCombinations {
                let word = String(w)
                // Get possible words from dictionary of words
                if let unscrambledWords: [String] = sortedWordsDictionary[String(String(w).sorted())] {
                    unscrambledWords.forEach { s in
                        let newWord = Word(word: s, scrabbleScore: 0, definitionExists: wordsWithDefinitions.contains(s), stared: staredWordsController.isWordStared(s))
                        if !words.contains(newWord) {
                            words.append(newWord)
                        }
                    }
                }
            }

            // Add words to the section
            if words.count > 0 {
                scrambledWords.append(Section(headerName: getFancySectionName(i), wordLength: i, words: words))
            }
        }
        return scrambledWords
    }
    
    public func doesDefinitionExistsForWord(_ word: String) -> Bool {
        return wordsWithDefinitions.contains(word )
    }

    private func getFancySectionName(_ wordLength: Int) -> String {
        return "Words of length \(wordLength)"
    }

    private func cleanWord(_ word: String) -> String {
        return word.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}
