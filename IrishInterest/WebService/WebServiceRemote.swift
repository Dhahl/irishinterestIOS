// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation

struct WebServiceRemote {
    
    private enum Const {
        static let baseURL: URL = URL(string: "https://irishinterest.ie/API/rest/request.php")!
        static let decoder = JSONDecoder()
    }
    
    func authors(session: URLSession = .shared,
                 completionHandler: @escaping (Result<ResponseAuthors, ErrorAuthors>) -> Void) -> Void {
//        let url = Const.baseURL
//        session.decodable(with: Const.baseURL,
//                          method: .get,
//                          parameters: nil, //FIX THIS ?value=categories&apiKey=testApiKey
//                          headers: nil,
//                          decoder: Const.decoder,
//                          completionHandler: { result in
//                            switch result {
//                            case .success(let authors):
//                                completionHandler(.success(authors))
//                            case .failure(let error):
//                                completionHandler(.failure(ErrorAuthors()))
//                            }
//                          }
//        )
    }
}