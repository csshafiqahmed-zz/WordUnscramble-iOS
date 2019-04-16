import Foundation
import UIKit

public struct WebDefinitions {

    public let title: String
    public let image: UIImage?
    public let url: String

    private init(title: String, image: UIImage?, url: String) {
        self.title = title
        self.image = image
        self.url = url
    }

    public static let MERRIAM_WEBSTER = WebDefinitions(title: "Merriam-Webster", image: Icon.internet_24, url: "https://www.merriam-webster.com/dictionary/")
    public static let DICTIONARY = WebDefinitions(title: "Dictionary.com", image: Icon.internet_24, url: "https://www.dictionary.com/browse/")
    public static let THESAURUS = WebDefinitions(title: "Thesaurus.com", image: Icon.internet_24, url: "https://www.thesaurus.com/browse/")
    public static let WIKIPEDIA = WebDefinitions(title: "Wikipedia", image: Icon.internet_24, url: "https://en.wikipedia.org/wiki/")
    public static let values = [MERRIAM_WEBSTER, DICTIONARY, THESAURUS, WIKIPEDIA]
}