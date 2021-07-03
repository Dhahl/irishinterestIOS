// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import RxSwift
import URLSessionDecodable
import UIKit

protocol WebService {
    func authors(searching: Observable<String?>) -> Observable<[Author]>
    func authors() -> Observable<[Author]>
    func categories() -> Observable<[Category]>
    func decode<T: Decodable>(data: Data) throws -> T
}

struct ResponseAuthors: Decodable {
    let response: [Author]
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
}

struct Category: Decodable {
    let id: Int
    let Name: String
    let Description: String
    
    var displayName: String {
        Name
    }
}
