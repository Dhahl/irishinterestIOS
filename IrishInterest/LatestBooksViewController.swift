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
        
        // 8 [ ] 8 [ ] 8
        let border: CGFloat = 8
        let columns: CGFloat = 2
        let screenWidth = UIScreen.main.bounds.smallestSide
        let columnWidth = ceil((screenWidth - 24) / columns)   // (3 * 8 border) = 24
        let rightMargin = screenWidth - columns * columnWidth - columns * border // compensate for rounding with the right margin
        
        layout.sectionInset = UIEdgeInsets(top: border, left: border, bottom: border, right: rightMargin)
        layout.minimumLineSpacing = border
        layout.minimumInteritemSpacing = border / 2
        layout.itemSize = CGSize(width: columnWidth, height: 270)

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
