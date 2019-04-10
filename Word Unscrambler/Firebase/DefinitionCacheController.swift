
public class DefinitionCacheController {

    private static var definitionCacheController: DefinitionCacheController!

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

    public func cacheWord(word: FirebaseWord) {
        cachedDefinitions[word.word!] = word
    }
}