import Foundation

public class StaredWordsController {

    private static var staredWordsController: StaredWordsController!

    private let key = "favorite_words"
    private var staredWords = [String]()

    private init() {
        let defaults = UserDefaults.standard
        staredWords = defaults.object(forKey: key) as? [String] ?? [String]()
    }

    public static func getInstance() -> StaredWordsController {
        if staredWordsController == nil {
            staredWordsController = StaredWordsController()
        }
        return staredWordsController
    }

    public func addWord(_ word: String) {
        staredWords.append(word)

        let defaults = UserDefaults.standard
        defaults.set(staredWords, forKey: key)
    }

    public func removeWord(_ word: String) {
        staredWords.removeAll(where: { $0 == word })

        let defaults = UserDefaults.standard
        defaults.set(staredWords, forKey: key)
    }

    public func isWordStared(_ word: String) -> Bool {
        let results = staredWords.filter { s in s == word }
        return results.count > 0
    }

    public func getStaredWords() -> [String] {
        return staredWords
    }

    public func getListOfWordObjects() -> [Word] {
        let unscrambler = UnScrambler.getInstance()
        var words = [Word]()
        for w in staredWords {
            words.append(Word(word: w, scrabbleScore: 0, definitionExists: unscrambler.doesDefinitionExistsForWord(w), stared: true))
        }
        return words
    }

}