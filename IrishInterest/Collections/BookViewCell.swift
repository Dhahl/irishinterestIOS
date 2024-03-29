// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift

final class BookViewCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    let imageView = UIImageView()
    var disposeBag = DisposeBag()
    
    public override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                selectedBackgroundView?.backgroundColor = Brand.colorCellHighlightedBackground
            } else {
                selectedBackgroundView?.backgroundColor = Brand.colorCellSelectedBackground
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let selectionView = UIView(frame: .zero)
        selectionView.isUserInteractionEnabled = false
        selectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        selectionView.backgroundColor = .systemFill
        selectedBackgroundView = selectionView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(book: Book, imageLoader: ImageLoader) {
        UI.fit(imageView, to: contentView, left: 0, right: 0, top: 0)
        imageView.backgroundColor = .tertiarySystemFill
        imageView.contentMode = .scaleAspectFit
        
        imageLoader.load(url: book.imageURL)
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        UI.caption1(label: authorLabel, text: book.author ?? "", nrOfLines: 1)
        UI.fit(authorLabel, to: contentView, left: 0, right: 0)
        authorLabel.textColor = .secondaryLabel
        authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: CellConst.authorHeight).isActive = true
        authorLabel.lineBreakMode = .byTruncatingTail
        authorLabel.adjustsFontSizeToFitWidth = false
        
        UI.body(label: titleLabel, text: book.displayTitle, nrOfLines: 1)
        UI.fit(titleLabel, to: self.contentView, left: 0, right: 0)
        titleLabel.textColor = .label
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.heightAnchor.constraint(equalToConstant: CellConst.titleHeight).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: authorLabel.topAnchor, constant: -CellConst.titleAuthorGap).isActive = true
        
        imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 0).isActive = true

        backgroundColor = .clear
    }
    
    func setAuthors(_ authors: [Author]) {
        authorLabel.text = authors.map { $0.displayName }.joined(separator: "; ")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        titleLabel.text = nil
        authorLabel.text = nil
        imageView.image = nil
    }
    
}
