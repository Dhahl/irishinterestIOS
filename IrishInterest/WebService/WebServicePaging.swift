// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import RxSwift

final class WebServicePaging {

    public let items: Observable<[Book]>

    private let serviceCall: (Int) -> Observable<[Book]>
    private let paging: Paging
    private var itemsSubject = PublishSubject<[Book]>()
    private var pagesLoading = Set<Int>()
    private let disposeBag = DisposeBag()

    init(serviceCall: @escaping (Int) -> Observable<[Book]>, pageSize: Int = 30) {
        self.serviceCall = serviceCall
        self.paging = Paging(size: pageSize)
        self.items = itemsSubject.asObservable()
    }

    public func start() {
        onDisplayed(index: -1)
    }

    public func onDisplayed(index: Int) {
        guard let nextPage = paging.nextPage(for: index) else {
            return
        }
        guard !pagesLoading.contains(nextPage) else {
            return
        }
        pagesLoading.insert(nextPage)
        serviceCall(nextPage)
            .subscribe(onNext: { [weak self] (books: [Book]) in
                self?.itemsSubject.onNext(books)
            }).disposed(by: disposeBag)
    }
}


struct Paging {
    
    let size: Int

    func nextPage(for index: Int) -> Int? {
        guard (index + 1) % size == 0 else {
            return nil
        }
        return (index + 1) / size
    }
}
