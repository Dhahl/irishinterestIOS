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
    private var webService: WebService!
    private var onSelected: ((Book) -> Void)?
    private var navTitle: String?
    private var state: CurrentState = .listAToZ
    private let warningLabel = UILabel()
    private let noResultsLabel = UILabel()
    
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
               onSelected: @escaping (Book) -> Void) {
        self.navTitle = title
        self.webService = webService
        self.onSelected = onSelected
    }
    
    private func update(_ newState: CurrentState) {
        state = newState
        switch state {
        case .listAToZ:
            warningLabel.isHidden = true
            noResultsLabel.isHidden = true
        case .listSearchResults:
            warningLabel.isHidden = true
            noResultsLabel.isHidden = true
        case .warningSearchTermTooShort(let count):
            warningLabel.isHidden = false
            noResultsLabel.isHidden = true
            warningLabel.text = Const.searchWarning(count: count)
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
        update(.listAToZ)
        
        showSearchBar(withPlaceholder: "Book titles")
        searchTextObservable
            .distinctUntilChanged()
            .flatMap { [weak self] (searchValue: String?) -> Observable<[Book]> in
                guard let strongSelf = self else { return .just([]) }
                guard let value = searchValue else {
                    strongSelf.update(.listSearchResults)
                    return .just([])
                }
                switch value.count {
                case 0:
                    strongSelf.update(.listAToZ)
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
                            strongSelf.noResultsLabel.isHidden = books.count != 0
                        }
                }
            }
            .bind(to: collectionView.rx.items(cellIdentifier: "BookViewCell")) { [weak self]
                (index: Int, model: Book, cell: BookViewCell) in
                guard let strongSelf = self else { return }
                strongSelf.models[index] = model
                cell.update(book: model, imageLoader: strongSelf.imageLoader)
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

private enum CurrentState {
    case listAToZ
    case listSearchResults
    case warningSearchTermTooShort(count: Int)
}
