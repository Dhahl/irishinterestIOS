// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum CellConst {
    
    // 8 [ ] 8 [ ] 8
    static let border: CGFloat = 8
    static let columns: CGFloat = 2
    static let totalBorders = (columns + 1) * border
    
    static func itemSizeAndSectionInset(forScreenWidth width: CGFloat) -> (CGSize, UIEdgeInsets) {
        let cellWidth = ceil((width - totalBorders) / columns)
        // compensate for rounding with the right margin
        let rightMargin = width - columns * cellWidth - columns * border
        
        let size = CGSize(width: cellWidth, height: ceil(cellWidth * CellConst.imageRatio) + CellConst.textAreaFullHeight)
        let insets = UIEdgeInsets(top: border, left: border, bottom: border, right: rightMargin)
        return (size, insets)
    }
    
    static let imageRatio: CGFloat = 1.5
    static let titleHeight: CGFloat = 32
    static let titleAuthorGap: CGFloat = -8
    static let authorHeight: CGFloat = 16
    
    static let textAreaFullHeight: CGFloat = titleHeight + titleAuthorGap + authorHeight
    
}

final class LatestBooksViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    private var webService: WebService!
    private let layout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView!
    private let imageLoader = ImageLoader()
    
    func setup(webService: WebService) {
        self.webService = webService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LatestBooksViewController")
        
        let screenWidth = UIScreen.main.bounds.smallestSide
        (layout.itemSize, layout.sectionInset) = CellConst.itemSizeAndSectionInset(forScreenWidth: screenWidth)
        
        layout.minimumLineSpacing = CellConst.border
        layout.minimumInteritemSpacing = CellConst.border / 2

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
            .bind(to: collectionView.rx.items(cellIdentifier: "BookViewCell")) { [weak self]
                (index: Int, model: Book, cell: BookViewCell) in
                guard let strongSelf = self else { return }
                cell.update(book: model, imageLoader: strongSelf.imageLoader)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
}
