// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class AuthorsByLetterViewController: UIViewController, SearchResultsObservable {
    
    let searchBar = UISearchBar()
    private var disposeBag = DisposeBag()
    
    private var authorsObservable: Observable<[Author]>!
    private var onSelected: ((Author) -> Void)?
    
    /// the first letter of the author we filtered for
    private var firstLetter: String!
    private var models: [Int: Author] = [:]
    private let layout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView!
    
    func setup(authorsObservable: Observable<[Author]>, byLetter: String, onSelected: @escaping (Author) -> Void) {
        self.authorsObservable = authorsObservable
        self.firstLetter = byLetter
        self.onSelected = onSelected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Author \(firstLetter ?? "")"
        print("AuthorsListedViewController")
        
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
        
        if let firstLetter = firstLetter {
            showSearchBar(withPlaceholder: "Authors starting with \(firstLetter)")
        }
        
        // ABC
        authorsObservable
            .doLoading(with: Loader(view: view))
            .bind(to: collectionView.rx.items(cellIdentifier: "TextViewCell")) { [weak self] (index: Int, model: Author, cell: TextViewCell) in
                cell.update(title: model.fullName)
                self?.models[index] = model
            }
            .disposed(by: disposeBag)
        
        // selection
        collectionView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (indexPath: IndexPath) in
                guard let model: Author = self?.models[indexPath.item] else { return }
                self?.onSelected?(model)
            }
            .disposed(by: disposeBag)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        print("AuthorsViewController.viewDidAppear")
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
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // reset search entry on switching tabs
        searchBar.text = ""
    }
}
