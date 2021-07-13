// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import RxSwift
import URLSessionDecodable
import UIKit

protocol WebService {
    var decoder: JSONDecoder { get }
    func authors() -> Observable<[Author]>
    func categories() -> Observable<[Category]>
    func books(page: Int) -> Observable<[Book]>
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

struct ResponseCategories: Decodable {
    let response: [Category]
    var responseSorted: [Category] {
        response.sorted { (a: Category, b: Category) in
            a.displayName <= b.displayName
        }
    }
}

struct Category: Decodable {
    let id: Int
    let Name: String
    let Description: String
    
    var displayName: String {
        Name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct Book: Decodable {
    let author: String
    let authorid: Int
    let title: String
    let genre: String
    let categoryid: Int
    let area: String
    let synopsis: String
    let id: Int
    let image: String
    var imageURL: URL? {
        guard !image.isEmpty else { return nil }
        return URL(string: "https://irishinterest.ie/uploads/\(image)")
    }
    let isbn: String?
    let isbn13: String
    let publisher: String
}
