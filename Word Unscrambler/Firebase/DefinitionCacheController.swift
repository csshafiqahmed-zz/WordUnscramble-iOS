import Foundation

public class DefinitionCacheController {

    /// Singleton static variable
    private static var definitionCacheController: DefinitionCacheController!

    /// Dictionary of definitions of word already pulled from Firebase,
    /// where key=word, value=Definition object
    private var cachedDefinitions: [String: FirebaseWord]!
    private var firebaseFetch: FirebaseFetch!

    private init() {
        self.cachedDefinitions = [String: FirebaseWord]()
        self.firebaseFetch = FirebaseFetch()
    }

    public static func getInstance() -> DefinitionCacheController {
        if definitionCacheController == nil {
            definitionCacheController = DefinitionCacheController()
        }
        return definitionCacheController
    }

    /**
        Given a word as a string, returns FirebaseFetchWordCompletion handler with the definition as the result
        Checks if the word exists in the cached definitions dictionary, if so return .success(definition)
        Else makes a Firebase Fetch call to retrieve the word and returns the result accordingly
     */
    public func getDefinitionForWord(_ word: String, completion: @escaping ((FirebaseFetchWordCompletion) -> Void)) {
        if let firebaseWord = cachedDefinitions[word] {
            completion(.success(firebaseWord))
        } else {
            firebaseFetch.fetchDefinitionForWord(word) { firebaseFetchWordCompletion in
                switch firebaseFetchWordCompletion {
                case .success(let firebaseWord):
                    self.cacheWord(word: firebaseWord)
                case .failure, .wordDoesNotExists:
                    ()
                }
                completion(firebaseFetchWordCompletion)
            }
        }
    }

    /**
        Caches a firebase word to the dictionary
     */
    public func cacheWord(word: FirebaseWord) {
        cachedDefinitions[word.word!] = word
    }
}