import FirebaseCore
import FirebaseDatabase

public class FirebasePush {

    private let firebaseReference: FirebaseReference!

    init() {
        firebaseReference = FirebaseReference()
    }

    public func pushFeedback(name: String, email: String, message: String) {
        let timestamp = String(Int(Date().timeIntervalSince1970 * 1000))
        let data: [String: Any] = ["name": name,
                                   "email": email,
                                   "message": message]
        let documentReference = firebaseReference.getFeedBackCollectionReference().document(timestamp)
        documentReference.setData(data)
    }
}