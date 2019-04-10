import Foundation

public enum FirebaseFetchWordCompletion {
    case success(_ word: FirebaseWord)
    case wordDoesNotExists
    case failure
}