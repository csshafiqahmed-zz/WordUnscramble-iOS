import FirebaseCore
import FirebaseFirestore

public class FirebaseFetch {

    private let firebaseReference: FirebaseReference!

    init() {
        firebaseReference = FirebaseReference()
    }

    /**
        Given a word as a string, makes a Firebase Fetch call to retrieve the document with the word as the ID
        If a error is thrown return .wordDoesNotExists
        else if document exists and is not nil return .success(definition)
        else return .failure
     */
    public func fetchDefinitionForWord(_ word: String, completion: @escaping ((FirebaseFetchWordCompletion) -> Void)) {
        let wordDocumentReference = firebaseReference.getDocumentReferenceForWord(word)
        wordDocumentReference.getDocument(completion: { (wordSnapshot, error) in
            if let error = error {
                print(error)
                completion(.wordDoesNotExists)
                return
            }

            if let document = wordSnapshot, document.exists {
                completion(.success(FirebaseWord(document: document)))
            } else {
                completion(.failure)
            }
        })
    }
}