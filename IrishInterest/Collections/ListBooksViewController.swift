// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class ListBooksViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    private let layout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView!
    private let imageLoader = ImageLoader()
    private var models: [Int: Book] = [:]
    private var booksProvider: Observable<[Book]>?
    private var onSelected: ((Book) -> Void)?
    private var onDisplaying: ((Int) -> Void)?
    private var navTitle: String?
    private var loader: Loader?
    
    func setup(title: String,
               booksProvider: Observable<[Book]>,
               onDisplaying: @escaping (Int) -> Void,
               onSelected: @escaping (Book) -> Void) {
        self.navTitle = title
        self.booksProvider = booksProvider
        self.onSelected = onSelected
        self.onDisplaying = onDisplaying
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.main.bounds.smallestSide
        (layout.itemSize, layout.sectionInset) = CellConst.itemSizeAndSectionInset(forScreenWidth: screenWidth)
        
        layout.minimumLineSpacing = CellConst.border
        layout.minimumInteritemSpacing = CellConst.border / 2

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(BookViewCell.self, forCellWithReuseIdentifier: "BookViewCell")
        collectionView.keyboardDismissMode = .onDrag
        
        setupTitle()
        
        view.addSubview(collectionView)
        UI.fit(collectionView, to: view, left: 0, right: 0, bottom: 0, top: 0)
        
        booksProvider?
            .doLoading(with: Loader(view: collectionView))
            .bind(to: collectionView.rx.items(cellIdentifier: "BookViewCell")) { [weak self]
                (index: Int, model: Book, cell: BookViewCell) in
                guard let strongSelf = self else { return }
                strongSelf.models[index] = model
                cell.update(book: model, imageLoader: strongSelf.imageLoader)
                strongSelf.onDisplaying?(index)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (indexPath: IndexPath) in
                guard let book: Book = self?.models[indexPath.item] else { return }
                self?.onSelected?(book)
            }
            .disposed(by: disposeBag)
    }
    
    func setupTitle() {
        if let navTitle = navTitle {
            navigationItem.title = navTitle
        }
    }
}
