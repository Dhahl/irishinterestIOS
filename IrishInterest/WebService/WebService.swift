// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import RxSwift
import URLSessionDecodable
import UIKit

protocol WebService {
    func authors() -> Observable<[Author]>
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
