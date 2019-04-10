import FirebaseCore
import FirebaseFirestore

public class FirebaseReference {

    private let firestore: Firestore!

    init() {
        firestore = Firestore.firestore()
    }

    public func getDefinitionsCollectionReference() -> CollectionReference {
        return firestore.collection(FirebaseKey.DEFINITIONS)
    }

    public func getDocumentReferenceForWord(_ word: String) -> DocumentReference {
        return getDefinitionsCollectionReference().document(word)
    }

}