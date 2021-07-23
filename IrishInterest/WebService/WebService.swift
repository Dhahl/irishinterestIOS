// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import RxSwift
import URLSessionDecodable
import UIKit

protocol WebService {
    var decoder: JSONDecoder { get }
    func authors() -> Observable<[Author]>
    func categories() -> Observable<[Category]>
    func latestBooks(page: Int) -> Observable<[Book]>
    func details(bookID: Int) -> Observable<BookDetails>
}

extension WebService {
    func decode<T: Decodable>(data: Data) throws -> T {
        try decoder.decode(T.self, from: data)
    }
}

struct ResponseAuthors: Decodable {
    let response: [Author]
    var responseSorted: [Author] {
        response.sorted { (a: Author, b: Author) in
            a.fullName <= b.fullName
        }
    }
}

struct ResponseBooks: Decodable {
    let response: [Book]
}

struct ErrorAuthors: Error {
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
    let author: String
    let authorid: Int?
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
    let area: String
    let author: String?
    let authorid: String?
    let categoryid: Int
    let ebook: Int
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
    let pages: Int
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
        BookDetails(area: "", author: nil, authorid: nil, categoryid: 0, ebook: 0, genre: "", hardback: 0, id: -1, isbn: nil, isbn13: "", language: "", pages: 0, paperback: 0, publisher: "", synopsis: "", title: "", vendor: nil, vendorurl: nil)
    }
}
