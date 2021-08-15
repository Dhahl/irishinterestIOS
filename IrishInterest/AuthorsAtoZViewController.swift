// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class AuthorsAtoZViewController: UIViewController, SearchResultsObservable {    
    
    let searchBar = UISearchBar()
    private var modelLetters: [Int: CountByLetter] = [:]
    private var modelFoundAuthors: [Int: Author] = [:]
    private var disposeBag = DisposeBag()
    private var webService: WebService!
    private var onSelectedFirstLetter: ((String) -> Void)?
    private var onSelected: ((Author) -> Void)?
    private let layout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView!
    private let searchLayout = UICollectionViewFlowLayout()
    private var searchCollectionView: UICollectionView!
    private var state: CurrentState = .listAToZ
    private let warningLabel = UILabel()
    
    private enum Const {
        static let minChar: Int = 4
        static func searchPlaceHolder(authorsCount: Int?) -> String {
            if let count = authorsCount {
                return "Search authors - \(count)"
            } else {
                return "Search authors"
            }
        }
        
        static func searchWarning(count: Int) -> String {
            let left = Const.minChar - count
            let characters = left == 1 ? "character" : "characters"
            return "\(left) more \(characters) to search..."
        }
    }
    
    func setup(webService: WebService,
               onSelectedFirstLetter: @escaping (String) -> Void,
               onSelected: @escaping (Author) -> Void) {
        self.webService = webService
        self.onSelectedFirstLetter = onSelectedFirstLetter
        self.onSelected = onSelected
    }
    
    private func update(_ newState: CurrentState) {
        state = newState
        switch state {
        case .listAToZ:
            collectionView.isHidden = false
            searchCollectionView.isHidden = true
            warningLabel.isHidden = true
        case .listSearchResults:
            collectionView.isHidden = true
            searchCollectionView.isHidden = false
            warningLabel.isHidden = true
        case .warningSearchTermTooShort(let count):
            collectionView.isHidden = true
            searchCollectionView.isHidden = true
            warningLabel.isHidden = false
            warningLabel.text = Const.searchWarning(count: count)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AuthorsViewController")
        
        // A-Z COLLECTION
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 8)
        layout.minimumLineSpacing = 0
        let itemWidth = UIScreen.main.bounds.smallestSide - 16
        layout.itemSize = CGSize(width: itemWidth, height: 48.0)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(TextWithDetailViewCell.self, forCellWithReuseIdentifier: "TextWithDetailViewCell")
        
        view.addSubview(collectionView)
        UI.fit(collectionView, to: view, left: 0, right: 0, bottom: 0, top: 0)
        
        // SEARCH COLLECTION
        searchLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 8)
        searchLayout.minimumLineSpacing = 0
        searchLayout.itemSize = CGSize(width: itemWidth, height: 48.0)
        
        searchCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: searchLayout)
        searchCollectionView.backgroundColor = .systemBackground
        searchCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchCollectionView.keyboardDismissMode = .onDrag
        searchCollectionView.register(TextViewCell.self, forCellWithReuseIdentifier: "TextViewCell")
        
        view.addSubview(searchCollectionView)
        UI.fit(searchCollectionView, to: view, left: 0, right: 0, bottom: 0, top: 0)
        
        // SEARCH WARNING
        UI.format(.subheadline, label: warningLabel, text: "", nrOfLines: 1)
        warningLabel.textColor = .secondaryLabel
        view.addSubview(warningLabel)
        UI.fit(warningLabel, to: view.safeAreaLayoutGuide, left: 24, right: 24, top: 16)
        update(.listAToZ)
        
        
        // SEARCH
        showSearchBar(withPlaceholder: Const.searchPlaceHolder(authorsCount: nil))
        searchTextObservable
            .map(Search.regexify(_:))
            .distinctUntilChanged()
            .flatMap { [weak self] (searchValue: String?) -> Observable<[Author]> in
                print("searched for: \(searchValue ?? "nil")")
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
                    return strongSelf.webService.authors(searchBy: value)
                        .doLoading(with: Loader(view: strongSelf.view))
                }
            }
            .bind(to: searchCollectionView.rx.items(cellIdentifier: "TextViewCell" )) {
                [weak self] (index: Int, author: Author, cell: TextViewCell) in
                cell.update(title: author.fullName)
                self?.modelFoundAuthors[index] = author
            }
            .disposed(by: disposeBag)
        
        // SEARCH RESULT SELECTION
        searchCollectionView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (indexPath: IndexPath) in
                guard let model: Author = self?.modelFoundAuthors[indexPath.item] else { return }
                self?.onSelected?(model)
            }
            .disposed(by: disposeBag)
        
        
        // AUTHORS COUNT
        webService.authorsCount()
            .doLoading(with: Loader(view: view))
            .map({ (count: Int) -> String in
                Const.searchPlaceHolder(authorsCount: count)
            })
            .bind(to: searchBar.rx.placeholder)
            .disposed(by: disposeBag)
        
        // ABC
        webService.authorsAtoZCount()
            .doLoading(with: Loader(view: view))
            .bind(to: collectionView.rx.items(cellIdentifier: "TextWithDetailViewCell")) { [weak self] (index: Int, countByLetter: CountByLetter, cell: TextWithDetailViewCell) in
                cell.update(title: countByLetter.alpha, detail: String(countByLetter.count))
                self?.modelLetters[index] = countByLetter
            }
            .disposed(by: disposeBag)
        
        // selection
        collectionView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (indexPath: IndexPath) in
                guard let model: CountByLetter = self?.modelLetters[indexPath.item] else { return }
                self?.onSelectedFirstLetter?(model.alpha)
            }
            .disposed(by: disposeBag)
    }
}


extension CGRect {
    var smallestSide: CGFloat {
        min(width, height)
    }
}

private enum CurrentState {
    case listAToZ
    case listSearchResults
    case warningSearchTermTooShort(count: Int)
}


enum Search {
    /// Create a regex like piped search value
    /// eg. from "joyce blunt" => "^joyce|blunt"
    /// - Parameter searchValue: input from the user
    /// - Returns: a regex friendly value
    static func regexify(_ searchValue: String) -> String {
        return searchValue.split { (char: Character) -> Bool in
            [" ", ",", ";"].contains(char)
        }.joined(separator: "|")
    }
}
