import Foundation

public struct TableViewSection {
    var headerName: String
    var wordLength: Int
    var words: [Word]
    var collapsed: Bool

    public init(headerName: String, wordLength: Int, words: [Word], collapsed: Bool = false) {
        self.headerName = headerName
        self.wordLength = wordLength
        self.words = words
        self.collapsed = collapsed
    }
}
