// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift

final class CategoriesViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    private var webService: WebService!
    private let layout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView!
    
    func setup(webService: WebService) {
        self.webService = webService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CategoriesViewController.viewDidLoad")
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 8)
        layout.minimumLineSpacing = 0
        let itemWidth = UIScreen.main.bounds.smallestSide - 16
        layout.itemSize = CGSize(width: itemWidth, height: 48.0)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(TextViewCell.self, forCellWithReuseIdentifier: "TextViewCell")
        
        view.addSubview(collectionView)
        UI.fit(collectionView, to: view, left: 0, right: 0, bottom: 0, top: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = "Categories"
        guard let searchController = (tabBarController as? SearchResultsObservable) else {
            fatalError("tabBarController is not a SearchResultsObservable")
        }
        searchController.showSearchBar(withPlaceholder: "Categories")
        // local filtering from observer without re-triggering fetch
        Observable.combineLatest(searchController.searchTextObservable,
                                 webService.categories()
                                    .doLoading(with: Loader(view: view))) { (query: String, list: [Category]) -> [Category] in
            guard !query.isEmpty else { return list }
            let queryLower = query.lowercased()
            return list.filter { (category: Category) -> Bool in
                category.displayName.lowercased().contains(queryLower)
            }
        }.bind(to: collectionView.rx.items(cellIdentifier: "TextViewCell")) { (index: Int, model: Category, cell: TextViewCell) in
            cell.update(title: model.displayName)
        }
        .disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // reset search entry on switching tabs
        (tabBarController as? SearchResultsObservable)?.searchBar.text = ""
        disposeBag = DisposeBag()
    }
}
