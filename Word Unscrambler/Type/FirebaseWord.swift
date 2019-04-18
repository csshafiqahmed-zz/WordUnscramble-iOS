import FirebaseFirestore

public class FirebaseWord {

    public private(set) var word: String?
    public private(set) var syllable: String?
    public private(set) var phonetic: [String]?
    public private(set) var definitions: [String: [String]]?

    init(document: DocumentSnapshot) {
        self.word = document.get(FirebaseKey.Word.WORD) as? String
        self.syllable = document.get(FirebaseKey.Word.SYLLABLE) as? String
        self.phonetic = document.get(FirebaseKey.Word.PHONETIC) as? [String]
        self.definitions = [String: [String]]()

        if let map = document.get(FirebaseKey.Word.DEFINITIONS) as? [String: Any] {
            for (key, value) in map {
                if let def = value as? [String] {
                    var list = [String]()
                    def.forEach { s in list.append(s.trimmingCharacters(in: .whitespacesAndNewlines)) }
                    list.sort()
                    self.definitions![key] = list
                }
            }
        }
    }
}