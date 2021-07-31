// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class AuthorsViewController: UIViewController, SearchResultsObservable {    
    private var disposeBag = DisposeBag()
    private var webService: WebService!
    private let layout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView!
    let searchBar = UISearchBar()
    
    func setup(webService: WebService) {
        self.webService = webService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AuthorsViewController")
        
        // collection
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
        print("AuthorsViewController.viewDidAppear")
        showSearchBar(withPlaceholder: "... Authors")
        
        webService.countAuthors()
            .doLoading(with: Loader(view: view))
            .map({ (count: Int) -> String in
                "\(count) Authors"
            })
            .bind(to: searchBar.rx.placeholder)
            .disposed(by: disposeBag)
        
//        // local filtering from observer without re-triggering fetch
//        Observable.combineLatest(searchTextObservable,
//                                 webService.authors()
//                                    .doLoading(with: Loader(view: view))) { (query: String, list: [Author]) -> [Author] in
//            guard !query.isEmpty else { return list }
//            let queryLower = query.lowercased()
//            return list.filter { (item: Author) -> Bool in
//                item.fullName.lowercased().contains(queryLower)
//            }
//        }.bind(to: collectionView.rx.items(cellIdentifier: "TextViewCell")) { (index: Int, model: Author, cell: TextViewCell) in
//            cell.update(title: model.fullName)
//        }
//        .disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // reset search entry on switching tabs
        searchBar.text = ""
        disposeBag = DisposeBag()
    }
}


extension CGRect {
    var smallestSide: CGFloat {
        min(width, height)
    }
}
