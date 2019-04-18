import Foundation

public struct Word: Equatable {
    var word: String
    var scrabbleScore: Int
    var definitionExists: Bool
    var stared: Bool

    public init(word: String, scrabbleScore: Int, definitionExists: Bool, stared: Bool) {
        self.word = word
        self.scrabbleScore = scrabbleScore
        self.definitionExists = definitionExists
        self.stared = stared
    }

    public static func ==(lhs: Word, rhs: Word) -> Bool {
        return lhs.word == rhs.word
    }
}