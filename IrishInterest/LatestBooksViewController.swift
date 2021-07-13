// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class LatestBooksViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    private var webService: WebService!
    private let layout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView!
    
    func setup(webService: WebService) {
        self.webService = webService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LatestBooksViewController")
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 8)
        layout.minimumLineSpacing = 0
        let itemWidth = UIScreen.main.bounds.smallestSide - 16
        layout.itemSize = CGSize(width: itemWidth, height: 48.0)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(BookViewCell.self, forCellWithReuseIdentifier: "BookViewCell")
        
        view.addSubview(collectionView)
        UI.fit(collectionView, to: view, left: 0, right: 0, bottom: 0, top: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let searchController = (tabBarController as? SearchResultsObservable)
        searchController?.hideSearchBar()
        
        webService.books(page: 0)
            .doLoading(with: Loader(view: view))
            .debug("books")
            .bind(to: collectionView.rx.items(cellIdentifier: "BookViewCell")) {
                (index: Int, model: Book, cell: BookViewCell) in
                cell.update(book: model)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
}
