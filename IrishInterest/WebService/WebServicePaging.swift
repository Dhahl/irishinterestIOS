// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import RxSwift

final class WebServicePaging {

    public let items: Observable<[Book]>

    private let serviceCall: (Int) -> Observable<[Book]>
    private let paging: Paging
    private var itemsSubject = BehaviorSubject<[Book]>(value: [])
    private var loadedPages = Set<Int>()
    private var nextPage = BehaviorSubject<Int>(value: 0)
    private let disposeBag = DisposeBag()

    init(serviceCall: @escaping (Int) -> Observable<[Book]>, pageSize: Int = 30) {
        self.serviceCall = serviceCall
        self.paging = Paging(size: pageSize)
        self.items = itemsSubject.asObservable()
        nextPage.flatMap({ page in
            serviceCall(page)
        }).subscribe(onNext: { [weak self] items in
            guard let self = self else { return }
            try? self.itemsSubject.onNext( self.itemsSubject.value() + items)
        }).disposed(by: disposeBag)
    }

    public func onDisplayed(index: Int) {
        guard let page = paging.nextPage(for: index) else { return }
        guard !loadedPages.contains(page) else { return }
        loadedPages.insert(page)
        nextPage.onNext(page)
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
