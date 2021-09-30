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
    private var authorsModels : AuthorsOfBooks = [:]
    private var booksProvider: Observable<[Book]>?
    private var authorsProvider: ((Observable<[Book]>) -> Observable<AuthorsOfBooks>)?
    private var onSelected: ((Book, [Author]) -> Void)?
    private var onDisplaying: ((Int) -> Void)?
    private var navTitle: String?
    private var loader: Loader?
    
    func setup(title: String,
               booksProvider: Observable<[Book]>,
               authorsProvider: @escaping (Observable<[Book]>) -> Observable<AuthorsOfBooks>,
               onDisplaying: @escaping (Int) -> Void,
               onSelected: @escaping (Book, [Author]) -> Void) {
        self.navTitle = title
        self.booksProvider = booksProvider
        self.authorsProvider = authorsProvider
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
                // set the authors if already known:
                if let authors: [Author] = strongSelf.authorsModels[String(model.id)] {
                    cell.setAuthors(authors)
                }
                strongSelf.onDisplaying?(index)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (indexPath: IndexPath) in
                guard let book: Book = self?.models[indexPath.item] else { return }
                let authors: [Author]
                if let storedAuthors = self?.authorsModels[String(book.id)] {
                    authors = storedAuthors
                } else {
                    authors = []
                }
                self?.onSelected?(book, authors)
            }
            .disposed(by: disposeBag)
        if let booksProvider = booksProvider {
            authorsProvider?(booksProvider)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] (authorsOfBooks: AuthorsOfBooks) in
                    guard let strongSelf = self else { return }
                    
                    // save the authors for later
                    strongSelf.authorsModels.merge(authorsOfBooks) { a, b in b }
                    
                    //find the cells if already exist, and update them
                    for (bookId, authors) in authorsOfBooks {
                        let bookIdInt = Int(bookId)
                        if let (index, _) = strongSelf.models.first(where: { (index: Int, book: Book) in
                            bookIdInt == book.id
                        }) {
                            if let cell = strongSelf.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? BookViewCell {
                                cell.setAuthors(authors)
                            }
                        }
                    }
                }).disposed(by: disposeBag)
        }
    }
    
    func setupTitle() {
        if let navTitle = navTitle {
            navigationItem.title = navTitle
        }
    }
}
