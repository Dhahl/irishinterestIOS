// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import RxSwift
import URLSessionDecodable
import UIKit

protocol WebService {
    var decoder: JSONDecoder { get }
    func authors() -> Observable<[Author]>
    func categories() -> Observable<[Category]>
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
