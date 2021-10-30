// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import RxSwift
import URLSessionDecodable
import UIKit

protocol WebService {
    var decoder: JSONDecoder { get }
    func authors() -> Observable<[Author]>
    func authors(searchBy value: String) -> Observable<[Author]>
    func authors(byLetter: String) -> Observable<[Author]>
    func authorsCount() -> Observable<Int>
    func authorsAtoZCount() -> Observable<[CountByLetter]>
    func authorDetails(authorId: Int) -> Observable<AuthorDetails>
    func authors(ofBooks observable: Observable<[Book]>) -> Observable<AuthorsOfBooks>
    func authors(byBookIds: [Int]) -> Observable<AuthorsOfBooks>
    
    func categories() -> Observable<[Category]>
    
    func books(searchBy value: String) -> Observable<[Book]>
    func booksLatest(page: Int) -> Observable<[Book]>
    func booksPublished(page: Int) -> Observable<[Book]>
    func books(byCategoryId: Int, page: Int) -> Observable<[Book]>
    func books(byAuthorID: Int, page: Int) -> Observable<[Book]>
    func booksComingSoon(page: Int) -> Observable<[Book]>
    func details(bookID: Int) -> Observable<BookDetails>
    
    func termsAndConditions() -> Observable<String>
    func privacyPolicy() -> Observable<String>
}

extension WebService {
    func decode<T: Decodable>(data: Data) throws -> T {
        try decoder.decode(T.self, from: data)
    }
}

struct CountByLetter: Decodable {
    let alpha: String
    let count: Int
}

typealias AuthorsOfBooks = [String: [Author]]

struct Author: Decodable {
    let id: Int
    let firstname: String
    let lastname: String
    var fullName: String {
        "\(lastname), \(firstname)"
    }
    var displayName: String {
        "\(firstname) \(lastname)"
    }
}

struct AuthorDetails: Decodable {
    let dob: String?
    let profile: String?
    let image: String?
    let altlink: String?
    let firstname: String?
    let lastname: String?
    
    var author: String {
        [firstname, lastname].compactMap { $0 }.joined(separator: " ")
    }
    
    var imageURL: URL? {
        guard let image = self.image, !image.isEmpty else { return nil }
        return URL(string: "https://irishinterest.ie/upload/\(image)")
    }
    
    
    /// Checks if there's anything useful we can shown as author bio details
    var isWorthToShow: Bool {
        if imageURL != nil { return true }
        if let profile = profile, !profile.isEmpty { return true }
        return false
    }
    
    static func empty() -> AuthorDetails {
        AuthorDetails(dob: nil, profile: nil, image: nil, altlink: nil, firstname: nil, lastname: nil)
    }
}

struct Category: Decodable {
    let id: Int
    let name: String
    
    var displayName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct Book: Codable, Equatable {
    let author: String?
    let authorid: Int
    let id: Int
    let image: String
    
    @available(*, deprecated, message: "use displayTitle instead")
    let title: String
    var displayTitle: String {
        title.trimmingCharacters(in: ["'", " "])
            .replacingOccurrences(of: "<br>", with: " ")
    }
    var imageURL: URL? {
        guard !image.isEmpty else { return nil }
        return URL(string: "https://irishinterest.ie/upload/\(image)")
    }
}

struct BookDetails: Decodable {
    var author: String {
        [firstname, lastname].compactMap { $0 }.joined(separator: " ")
    }
    let authorid: Int
    let categoryid: Int
    let ebook: Int
    let firstname: String
    let genre: String
    let hardback: Int
    let id: Int
    let isbn: String?
    let isbn13: String
    var isbnToDisplay: String {
        if isbn13.isEmpty {
            return isbn ?? ""
        } else {
            return isbn13
        }
    }
    let language: String
    let lastname: String
    let pages: Int?
    let paperback: Int
    let publisher: String
    let synopsis: String
    var synopsisToDisplay: String {
        synopsis
            .replacingOccurrences(of: "\r\n\r\n", with: "\r\n")
            .replacingOccurrences(of: "\r\n\r\n", with: "\r\n")
            .replacingOccurrences(of: "\n\n", with: "\n")
            .replacingOccurrences(of: "<br>", with: "\n")
            .trimmingCharacters(in: ["'"])
    }
    let title: String
    let vendor: String?
    let vendorurl: String?
    let published: String?
    
    static func empty() -> BookDetails {
        BookDetails(authorid: -1, categoryid: 0, ebook: 0, firstname: "", genre: "", hardback: 0, id: -1, isbn: nil, isbn13: "", language: "", lastname: "", pages: 0, paperback: 0, publisher: "", synopsis: "", title: "", vendor: nil, vendorurl: nil, published: nil)
    }
    
    var textToShare: String {
        author + " - " + title
    }
    
    var linkToShare: URL {
        URL(string: "https://www.irishinterest.ie/book/?id=\(id)")!
    }
    
    var twitterURL: URL {
        URL(string: "https://twitter.com/Irish1nterest?ref_src=twsrc%5Etfw%7Ctwcamp%5Eembeddedtimeline%7Ctwterm%5Eprofile%3AIrish1nterest%7Ctwgr%5EeyJ0ZndfZXhwZXJpbWVudHNfY29va2llX2V4cGlyYXRpb24iOnsiYnVja2V0IjoxMjA5NjAwLCJ2ZXJzaW9uIjpudWxsfSwidGZ3X2hvcml6b25fdHdlZXRfZW1iZWRfOTU1NSI6eyJidWNrZXQiOiJodGUiLCJ2ZXJzaW9uIjpudWxsfSwidGZ3X3NwYWNlX2NhcmQiOnsiYnVja2V0Ijoib2ZmIiwidmVyc2lvbiI6bnVsbH19&ref_url=https%3A%2F%2Firishinterest.ie%2F%23searchresults")!
    }
    
    var facebookURL: URL {
        URL(string: "https://www.facebook.com/sharer/sharer.php?u=irishinterest.ie/book/?id=\(id)")!
    }
    
    var youtubeURL: URL {
        URL(string: "https://www.youtube.com/channel/UCBVh-eIxXZEfh_BK9r8wwdQ")!
    }
    
    var instagramURL: URL {
        URL(string: "https://www.instagram.com/irish1nterest")!
    }
}
