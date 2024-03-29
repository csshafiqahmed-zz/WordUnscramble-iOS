import UIKit

public class UnScrambler {

    /// Singleton static variable
    private static var unscrambler: UnScrambler!

    /// Set of all words from text file
    public private(set) var allWords = Set<String>()
    /// Set of words with definitions in Firebase
    public private(set) var wordsWithDefinitions = Set<String>()
    /// Set of words without definitions in Firebase
    public private(set) var wordsWithoutDefinitions = Set<String>()
    /// Dictionary with each letter in the alphabet mapped to its appropriate scrabble score
    public private(set) var scrabbleCharacterPointsArray = [Character: Int]()
    /// Dictionary of strings mapped to a list of valid words with the set of letters
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

    /**
        Loads words from the text files into the variables
     */
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

    /**
        Creates the dictionary with each letter in the alphabet with its associated scrabble score
     */
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
        self.allWords.forEach { word in
            let sortedWord = String(word.sorted())

            if self.sortedWordsDictionary.keys.contains(sortedWord) {
                self.sortedWordsDictionary[sortedWord]?.append(word)
            } else {
                self.sortedWordsDictionary[sortedWord] = [word]
            }
        }
    }

    public func unscrambleWord(_ unscrambledWord: String) -> [TableViewSection] {
        let staredWordsController = StaredWordsController.getInstance()
        var scrambledWords = [TableViewSection]()
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
                scrambledWords.append(TableViewSection(headerName: getFancySectionName(i), wordLength: i, words: words))
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
