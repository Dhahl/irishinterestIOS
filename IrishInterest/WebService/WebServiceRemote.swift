// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import RxSwift
import URLSessionDecodable

struct WebServiceRemote: WebService {
    
    let decoder = JSONDecoder()
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    private enum Const {
        static let baseURL: URL = URL(string: "https://irishinterest.ie/API2/rest/request.php")!
        static func url(params: String) -> URL {
            URL(string: params, relativeTo: baseURL)!
        }
    }
    
    func authors() -> Observable<[Author]> {
        let params: String = "?value=authors&type=getAll&apiKey=testApiKey&offset=0"
        let request = URLRequest(url: Const.url(params: params))
        return session.rx.data(request: request).map { (data: Data) -> [Author] in
            try decode(data: data)
        }.catch({ (error: Error) in
            print(error)
            throw error
        }).catchAndReturn([])
    }
    
    func authors(byLetter: String) -> Observable<[Author]> {
        let params: String = "?value=authors&type=byLastNameStartsWith&apiKey=testApiKey&startsWith=\(byLetter)"
        let request = URLRequest(url: Const.url(params: params))
        return session.rx.data(request: request).map { (data: Data) -> [Author] in
            try decode(data: data)
        }.catch({ (error: Error) in
            print(error)
            throw error
        }).catchAndReturn([])
    }
    
    func countAuthors() -> Observable<Int> {
        let params: String = "?value=authors&type=count&apiKey=testApiKey"
        let request = URLRequest(url: Const.url(params: params))
        return session.rx.data(request: request).map { (data: Data) -> Int in
            try decode(data: data)
        }.catch({ (error: Error) in
            print(error)
            throw error
        }).catchAndReturn(42499)
    }
    
    func countAuthorsABC() -> Observable<[CountByLetter]> {
        let params: String = "?value=authors&type=abcCount&apiKey=testApiKey"
        let request = URLRequest(url: Const.url(params: params))
        return session.rx.data(request: request).map { (data: Data) -> [CountByLetter] in
            let counts: [CountByLetter] = try decode(data: data)
            return counts.filter { (countBy: CountByLetter) -> Bool in
                countBy.alpha.first?.isLetter == true
            }
        }.catch({ (error: Error) in
            print(error)
            throw error
        }).catchAndReturn([])
    }
    
    func categories() -> Observable<[Category]> {
        let params: String = "?value=categories&apiKey=testApiKey"
        let request = URLRequest(url: Const.url(params: params))
        return session.rx.data(request: request).map { (data: Data) -> [Category] in
            try decode(data: data)
        }.catch({ (error: Error) in
            print(error)
            throw error
        }).catchAndReturn([])
    }
    
    func booksBy(categoryId: Int) -> Observable<[Book]> {
        let params: String = "?value=books&type=byCategory&categoryId=\(categoryId)&offset=0&apiKey=testApiKey"
        let request = URLRequest(url: Const.url(params: params))
        return session.rx.data(request: request).compactMap { (data: Data) -> [Book] in
            try decode(data: data)
        }.catch({ (error: Error) in
            print(error)
            throw error
        }).catchAndReturn([])
    }
    
    func latestBooks(page: Int) -> Observable<[Book]> {
        let params: String = "?value=books&type=getLatest2&apiKey=testApiKey&offset=\(page)"
        let request: URLRequest = URLRequest(url: Const.url(params: params))
        return session.rx.data(request: request).compactMap { (data: Data) -> [Book] in
            try decode(data: data)
        }.catch({ (error: Error) in
            print(error)
            throw error
        }).catchAndReturn([])
    }
    
    func publishedBooks(page: Int) -> Observable<[Book]> {
        let params: String = "?value=books&type=getLatest2&apiKey=testApiKey&offset=\(page)"
        let request: URLRequest = URLRequest(url: Const.url(params: params))
        return session.rx.data(request: request).compactMap { (data: Data) -> [Book] in
            try decode(data: data)
        }.catch({ (error: Error) in
            print(error)
            throw error
        }).catchAndReturn([])
    }
    
    func details(bookID: Int) -> Observable<BookDetails> {
        let params: String = "?value=books&type=getById2&apiKey=testApiKey&bookId=\(bookID)"
        let request: URLRequest = URLRequest(url: Const.url(params: params))
        return session.rx.data(request: request).compactMap { (data: Data) -> BookDetails in
            try decode(data: data)
        }.catch({ (error: Error) in
            print(error)
            throw error
        }).catchAndReturn(BookDetails.empty())
    }
}
