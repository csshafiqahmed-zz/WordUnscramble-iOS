import Foundation

public class StaredWordsController {

    /// Singleton static variable
    private static var staredWordsController: StaredWordsController!

    /// UserDefaults key
    private let key = "favorite_words"
    /// List of words stared
    private var staredWords = [String]()
    private var firebaseEvents: FirebaseEvents!

    private init() {
        let defaults = UserDefaults.standard
        staredWords = defaults.object(forKey: key) as? [String] ?? [String]()
        firebaseEvents = FirebaseEvents()
    }

    public static func getInstance() -> StaredWordsController {
        if staredWordsController == nil {
            staredWordsController = StaredWordsController()
        }
        return staredWordsController
    }

    /**
        Adds a word to the stared list locally and updates it in UserDefaults
     */
    public func addWord(_ word: String) {
        staredWords.append(word)

        let defaults = UserDefaults.standard
        defaults.set(staredWords, forKey: key)

        firebaseEvents.logAddedWordToFavorite()
    }

    /**
        Removes a word from the stared list locally and updates it in UserDefaults
     */
    public func removeWord(_ word: String) {
        staredWords.removeAll(where: { $0 == word })

        let defaults = UserDefaults.standard
        defaults.set(staredWords, forKey: key)

        firebaseEvents.logRemovedWordFromFavorite()
    }

    /**
        Returns true if word is in the list of stared words, else false
     */
    public func isWordStared(_ word: String) -> Bool {
        let results = staredWords.filter { s in s == word }
        return results.count > 0
    }

    public func getStaredWords() -> [String] {
        return staredWords
    }

    /**
        Returns a converted list of string words to list Word objects
     */
    public func getListOfWordObjects() -> [Word] {
        let unscrambler = UnScrambler.getInstance()
        var words = [Word]()
        for w in staredWords {
            words.append(Word(word: w, scrabbleScore: 0, definitionExists: unscrambler.doesDefinitionExistsForWord(w), stared: true))
        }
        return words
    }

}