// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController, SearchResultsObservable {
    
    let searchBar = UISearchBar()
    private let disposeBag = DisposeBag()
    private let layout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView!
    private let imageLoader = ImageLoader()
    private var models: [Int: Book] = [:]
    private var authorsModels : AuthorsOfBooks = [:]
    private var webService: WebService!
    private var webServiceAuthors: WebServiceAuthors!
    private var onSelected: ((Book, [Author]) -> Void)?
    private var navTitle: String?
    private var state: CurrentState = .empty
    private let warningLabel = UILabel()
    private let noResultsLabel = UILabel()
    private var dissmissByTap: UITapGestureRecognizer?
    
    private enum Const {
        static let minChar: Int = 4
        static let noResults = "No search results."
        
        static func searchWarning(count: Int) -> String {
            let left = Const.minChar - count
            let characters = left == 1 ? "character" : "characters"
            return "\(left) more \(characters) to search..."
        }
    }
    
    func setup(title: String,
               webService: WebService,
               onSelected: @escaping (Book, [Author]) -> Void) {
        self.navTitle = title
        self.webService = webService
        self.webServiceAuthors = WebServiceAuthors(webService: webService)
        self.onSelected = onSelected
    }
    
    private func update(_ newState: CurrentState) {
        state = newState
        switch state {
        case .empty:
            noResultsLabel.isHidden = true
            if let gesture = dissmissByTap {
                view.addGestureRecognizer(gesture)
            }
        case .noResults:
            noResultsLabel.isHidden = false
            if let gesture = dissmissByTap {
                view.addGestureRecognizer(gesture)
            }
        case .listSearchResults:
            warningLabel.isHidden = true
            noResultsLabel.isHidden = true
            if let gesture = dissmissByTap {
                view.removeGestureRecognizer(gesture)
            }
        case .warningSearchTermTooShort(let count):
            warningLabel.isHidden = false
            noResultsLabel.isHidden = true
            warningLabel.text = Const.searchWarning(count: count)
            if let gesture = dissmissByTap {
                view.addGestureRecognizer(gesture)
            }
        }
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
        dissmissByTap = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        
        UI.fit(collectionView, to: view, left: 0, right: 0, bottom: 0, top: 0)
        
        // SEARCH WARNING
        UI.format(.subheadline, label: warningLabel, text: "", nrOfLines: 1)
        warningLabel.textColor = .secondaryLabel
        view.addSubview(warningLabel)
        UI.fit(warningLabel, to: view.safeAreaLayoutGuide, left: 24, right: 24, top: 16)
        
        // NO RESULTS LABEL
        UI.format(.subheadline, label: noResultsLabel, text: Const.noResults, nrOfLines: 1)
        noResultsLabel.textColor = .secondaryLabel
        view.addSubview(noResultsLabel)
        UI.fit(noResultsLabel, to: view.safeAreaLayoutGuide, left: 24, right: 24, top: 16)
        noResultsLabel.isHidden = true
        
        // INITIAL STATE
        update(.empty)
        
        showSearchBar(withPlaceholder: "Book titles")
        
        let booksObservable: Observable<[Book]> = searchTextObservable.distinctUntilChanged()
            .flatMap { [weak self] (searchValue: String?) -> Observable<[Book]> in
                guard let strongSelf = self else { return .just([]) }
                guard let value = searchValue else {
                    strongSelf.update(.empty)
                    return .just([])
                }
                switch value.count {
                case 0:
                    strongSelf.update(.empty)
                    return .just([])
                case 1..<Const.minChar:
                    strongSelf.update(.warningSearchTermTooShort(count: value.count))
                    return .just([])
                default: //above Const.minChar
                    strongSelf.update(.listSearchResults)
                    return strongSelf.webService.books(searchBy: value)
                        .observe(on: MainScheduler.instance)
                        .doLoading(with: Loader(view: strongSelf.view))
                        .do { (books: [Book]) in
                            if books.count == 0 {
                                strongSelf.update(.noResults)
                            }
                        }
                }
            }
        
        let authorsObservable: Observable<AuthorsOfBooks> = booksObservable.flatMap {
            [weak self] (books: [Book]) -> Observable<AuthorsOfBooks> in
            guard let strongSelf = self else { return .just([:]) }
            return strongSelf.webServiceAuthors.authors(byBookIds: books.map { $0.id })
        }
        
        booksObservable
            .bind(to: collectionView.rx.items(cellIdentifier: "BookViewCell")) { [weak self]
                (index: Int, model: Book, cell: BookViewCell) in
                guard let strongSelf = self else { return }
                strongSelf.models[index] = model
                cell.update(book: model, imageLoader: strongSelf.imageLoader)
                if let authors: [Author] = self?.authorsModels[String(model.id)] {
                    cell.setAuthors(authors)
                }
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (indexPath: IndexPath) in
                guard let book: Book = self?.models[indexPath.item] else { return }
                let authors: [Author]
                if let storedAuthors: [Author] = self?.authorsModels[String(book.id)] {
                    authors = storedAuthors
                } else {
                    authors = []
                }
                self?.onSelected?(book, authors)
            }
            .disposed(by: disposeBag)
        
        authorsObservable
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
    
    func setupTitle() {
        if let navTitle = navTitle {
            navigationItem.title = navTitle
        }
    }
    
    @objc func dissmissKeyboard() {
        searchBar.endEditing(true)
    }
}

private enum CurrentState {
    case empty
    case noResults
    case listSearchResults
    case warningSearchTermTooShort(count: Int)
}
