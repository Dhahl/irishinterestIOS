// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift

final class CategoriesViewController: UIViewController, SearchResultsObservable {
    
    private var disposeBag = DisposeBag()
    private var webService: WebService!
    private let layout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView!
    let searchBar = UISearchBar()
    private var models: [Int: Category] = [:]
    private var onSelected: ((Int, String) -> Void)?
    
    func setup(webService: WebService, onSelected: @escaping(Int, String) -> Void) {
        self.webService = webService
        self.onSelected = onSelected
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
        
        setMiniLogoAsNavItem()

        title = "Categories"
        showSearchBar(withPlaceholder: "Categories")
        // local filtering from observer without re-triggering fetch
        Observable.combineLatest(searchTextObservable,
                                 webService.categories()
                                    .doLoading(with: Loader(view: view))) { (query: String, list: [Category]) -> [Category] in
            guard !query.isEmpty else { return list }
            let queryLower = query.lowercased()
            return list.filter { (category: Category) -> Bool in
                category.displayName.lowercased().contains(queryLower)
            }
        }.bind(to: collectionView.rx.items(cellIdentifier: "TextViewCell")) { [weak self] (index: Int, model: Category, cell: TextViewCell) in
            self?.models[index] = model
            cell.update(title: model.displayName)
        }
        .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (indexPath: IndexPath) in
                guard let model: Category = self?.models[indexPath.item] else { return }
                self?.onSelected?(model.id, model.displayName)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // reset search entry on switching tabs
        searchBar.text = ""
    }
    
    func setMiniLogoAsNavItem() {
        let logoImage = UIImage(named: "logo_g2_cut")!.image(alpha: 0.382)!
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit
        let buttonItem = UIBarButtonItem(customView: logoImageView)
        navigationItem.rightBarButtonItem = buttonItem
        logoImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
    }
}
