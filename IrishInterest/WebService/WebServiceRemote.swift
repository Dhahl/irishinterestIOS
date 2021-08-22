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
        static let pageSize = 30
        static let baseURL: URL = URL(string: "https://irishinterest.ie/API2/rest/request.php")!
        static func url(params: String) -> URL {
            URL(string: params, relativeTo: baseURL)!
        }
    }
    
    // MARK: Authors
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
    
    func authors(searchBy value: String) -> Observable<[Author]> {
        let paramStrings: [String: String] = [
            "value": "authors",
            "type": "searchByName",
            "apiKey": "testApiKey",
            "searchBy": value
        ]
        let queryItems: [URLQueryItem] = paramStrings.map { (key: String, value: String) -> URLQueryItem in
            URLQueryItem(name: key, value: value)
        }
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "irishinterest.ie"
        urlComponents.path = "/API2/rest/request.php"
        urlComponents.queryItems = queryItems
        
        guard let url: URL = urlComponents.url else {
            print("ERROR: invalid url of components: \(urlComponents.debugDescription)")
            return .just([])
        }
        
        let request = URLRequest(url: url)
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
    
    func authorsCount() -> Observable<Int> {
        let params: String = "?value=authors&type=count&apiKey=testApiKey"
        let request = URLRequest(url: Const.url(params: params))
        return session.rx.data(request: request).map { (data: Data) -> Int in
            try decode(data: data)
        }.catch({ (error: Error) in
            print(error)
            throw error
        }).catchAndReturn(42499)
    }
    
    func authorsAtoZCount() -> Observable<[CountByLetter]> {
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
    
    // MARK: Categories
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
    
    // MARK: Books
    func books(searchBy value: String) -> Observable<[Book]> {
        let paramStrings: [String: String] = [
            "value": "books",
            "type": "searchByName",
            "apiKey": "testApiKey",
            "searchBy": value
        ]
        let queryItems: [URLQueryItem] = paramStrings.map { (key: String, value: String) -> URLQueryItem in
            URLQueryItem(name: key, value: value)
        }
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "irishinterest.ie"
        urlComponents.path = "/API2/rest/request.php"
        urlComponents.queryItems = queryItems
        
        guard let url: URL = urlComponents.url else {
            print("ERROR: invalid url of components: \(urlComponents.debugDescription)")
            return .just([])
        }
        
        let request = URLRequest(url: url)
        return session.rx.data(request: request).map { (data: Data) -> [Book] in
            try decode(data: data)
        }.catch({ (error: Error) in
            print(error)
            throw error
        }).catchAndReturn([])
    }
    
    func books(byAuthorID authorID: Int, page: Int) -> Observable<[Book]> {
        let params: String = "?value=books&type=byAuthorID&authorID=\(authorID)&offset=\(page * Const.pageSize)&apiKey=testApiKey"
        let request = URLRequest(url: Const.url(params: params))
        return session.rx.data(request: request).compactMap { (data: Data) -> [Book] in
            try decode(data: data)
        }.catch({ (error: Error) in
            print(error)
            throw error
        }).catchAndReturn([])
    }
    
    func books(byCategoryId: Int, page: Int) -> Observable<[Book]> {
        let params: String = "?value=books&type=byCategory&categoryId=\(byCategoryId)&offset=\(page * Const.pageSize)&apiKey=testApiKey"
        let request = URLRequest(url: Const.url(params: params))
        return session.rx.data(request: request).compactMap { (data: Data) -> [Book] in
            try decode(data: data)
        }.catch({ (error: Error) in
            print(error)
            throw error
        }).catchAndReturn([])
    }
    
    func booksLatest(page: Int) -> Observable<[Book]> {
        let params: String = "?value=books&type=getLatest2&apiKey=testApiKey&offset=\(page * Const.pageSize)"
        let request: URLRequest = URLRequest(url: Const.url(params: params))
        return session.rx.data(request: request).compactMap { (data: Data) -> [Book] in
            return try decode(data: data)
        }.catch({ (error: Error) in
            print(error)
            throw error
        }).catchAndReturn([])
    }
    
    func booksPublished(page: Int) -> Observable<[Book]> {
        let params: String = "?value=books&type=getPublished&apiKey=testApiKey&offset=\(page * Const.pageSize)"
        let request: URLRequest = URLRequest(url: Const.url(params: params))
        return session.rx.data(request: request).compactMap { (data: Data) -> [Book] in
            return try decode(data: data)
        }.catch({ (error: Error) in
            print(error)
            throw error
        }).catchAndReturn([])
    }
    
    func booksComingSoon(page: Int) -> Observable<[Book]> {
        let params: String = "?value=books&type=getComingSoon&apiKey=testApiKey&offset=\(page * Const.pageSize)"
        let request: URLRequest = URLRequest(url: Const.url(params: params))
        return session.rx.data(request: request).compactMap { (data: Data) -> [Book] in
            return try decode(data: data)
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
    
    func termsAndConditions() -> Observable<String> {
        let params: String = "?value=termsAndConditions&apiKey=testApiKey"
        let request = URLRequest(url: Const.url(params: params))
        return session.rx.data(request: request).compactMap { (data: Data) -> String in
            try decode(data: data)
        }.catch({ (error: Error) in
            print(error)
            throw error
        }).catchAndReturn("")
    }
    
    func privacyPolicy() -> Observable<String> {
        let params: String = "?value=privacyPolicy&apiKey=testApiKey"
        let request = URLRequest(url: Const.url(params: params))
        return session.rx.data(request: request).compactMap { (data: Data) -> String in
            try decode(data: data)
        }.catch({ (error: Error) in
            print(error)
            throw error
        }).catchAndReturn("")
    }
}
