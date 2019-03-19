import Foundation

public struct Section {
    var name: String
    var items: [Item]
    var collapsed: Bool

    public init(name: String, items: [Item], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

public struct Item {
    var name: String

    public init(name: String) {
        self.name = name
    }
}