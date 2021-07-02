// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import URLSessionDecodable
import UIKit

protocol WebService {
    func author() -> Result<[Author], ErrorAuthors>
}

struct ResponseAuthors: Decodable {
    let response: [Author]
}

struct ErrorAuthors: Error {
}

struct Author: Decodable {
    let id: Int
    let Name: String
    let Description: String
}
