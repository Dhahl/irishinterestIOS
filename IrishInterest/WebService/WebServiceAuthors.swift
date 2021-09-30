// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import RxSwift

final class WebServiceAuthors {
    
    private var webService: WebService
    private var authorsOfBooks: AuthorsOfBooks = [:]
    private let dispatchQueue = DispatchQueue(label: "authorsDictQueue")
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func authors(byBookIds: [Int]) -> Observable<AuthorsOfBooks> {
        //check which bookids we already have:
        var knowAuthors: AuthorsOfBooks = [:]
        var remainingIds: [Int] = []
        for id in byBookIds {
            if let authors:[Author] = authorsOfBooks[String(id)] {
                dispatchQueue.sync {
                    knowAuthors.merge([String(id): authors]) { a, b in a }
                }
            } else {
                remainingIds.append(id)
            }
        }
        
        if remainingIds.isEmpty {
            return .just(knowAuthors)
        }
        
        return Observable.merge(.just(knowAuthors),
                                webService.authors(byBookIds: remainingIds)
                                    .do(onNext: { [weak self] (recievedAuthors: [String : [Author]]) in
            self?.dispatchQueue.sync {
                self?.authorsOfBooks.merge(recievedAuthors) { a, b in b }
            }
        })
        )
    }
}
