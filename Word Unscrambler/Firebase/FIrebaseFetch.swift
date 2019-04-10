import FirebaseCore
import FirebaseFirestore

public class FirebaseFetch {

    private let firebaseReference: FirebaseReference!

    init() {
        firebaseReference = FirebaseReference()
    }

    public func fetchDefinitionForWord(_ word: String, completion: @escaping ((FirebaseFetchWordCompletion) -> Void)) {
        let wordDocumentReference = firebaseReference.getDocumentReferenceForWord(word)
        wordDocumentReference.getDocument(completion: { (wordSnapshot, error) in
            if let error = error {
                print(error)
                completion(.wordDoesNotExists)
                // TODO Log
                return
            }

            if let document = wordSnapshot, document.exists {
                completion(.success(FirebaseWord(document: document)))
                // TODO log
            } else {
                completion(.failure)
            }
        })
    }
}