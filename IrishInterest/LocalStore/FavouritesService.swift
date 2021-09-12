// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import RxSwift

protocol FavouriteService {
    func isFavourite(book: Book) -> Observable<Bool>
    func toggle(book: Book)
}

final class FavouritesObservable: FavouriteService {
    
    var booksObservable: Observable<[Book]> {
        books.asObservable()
    }
    
    private let books: BehaviorSubject<[Book]>
    
    init(stored: [Book]) {
        self.books = BehaviorSubject<[Book]>(value: stored)
    }
    
    public func isFavourite(book: Book) -> Observable<Bool> {
        books.map { (books: [Book]) in
            books.contains { (b:Book) in
                b.id == book.id
            }
        }
    }
    
    public func toggle(book: Book) {
        if let localBooks = try? books.value() {
            if localBooks.contains(where: { (b: Book) in b.id == book.id }) {
                var newBooks = localBooks
                newBooks.removeAll { (b: Book) in b.id == book.id }
                books.onNext(newBooks)
            } else {
                var newBooks = localBooks
                newBooks.append(book)
                books.onNext(newBooks)
            }
        }
    }
}
