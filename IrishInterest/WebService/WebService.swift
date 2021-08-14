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
    
    func categories() -> Observable<[Category]>
    
    func booksLatest(page: Int) -> Observable<[Book]>
    func booksPublished(page: Int) -> Observable<[Book]>
    func books(byCategoryId: Int, page: Int) -> Observable<[Book]>
    func books(byAuthorID: Int, page: Int) -> Observable<[Book]>
    func booksComingSoon(page: Int) -> Observable<[Book]>
    func details(bookID: Int) -> Observable<BookDetails>
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

struct Author: Decodable {
    let id: Int
    let firstname: String
    let lastname: String
    var fullName: String {
        "\(lastname), \(firstname)"
    }
}

struct Category: Decodable {
    let id: Int
    let name: String
    
    var displayName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct Book: Decodable {
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
    
    static func empty() -> BookDetails {
        BookDetails(authorid: -1, categoryid: 0, ebook: 0, firstname: "", genre: "", hardback: 0, id: -1, isbn: nil, isbn13: "", language: "", lastname: "", pages: 0, paperback: 0, publisher: "", synopsis: "", title: "", vendor: nil, vendorurl: nil)
    }
}
