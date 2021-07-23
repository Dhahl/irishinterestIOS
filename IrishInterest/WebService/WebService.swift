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
    let authorid: Int?
    let categoryid: Int
    let ebook: Int
    let genre: String
    let hardback: Int
    let id: Int
    let isbn: String?
    let isbn13: String
    let language: String
    let pages: Int
    let paperback: Int
    let publisher: String
    let synopsis: String
    let title: String
    let vendor: String?
    let vendorurl: String?
}
