// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit

final class BookViewCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    let imageView = UIImageView()
    
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
    
    func update(book: Book) {
        imageView.backgroundColor = .tertiarySystemFill
        
        UI.fit(imageView, to: contentView, left: 0, right: 0, top: 0)
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.contentMode = .scaleAspectFit
        
        UI.caption1(label: authorLabel, text: book.author, nrOfLines: 1)
        UI.fit(authorLabel, to: contentView, left: 0, right: 0)
        authorLabel.textColor = .secondaryLabel
        authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true // discussable
        authorLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        authorLabel.lineBreakMode = .byTruncatingTail
        authorLabel.adjustsFontSizeToFitWidth = false
        
        UI.body(label: titleLabel, text: book.title.trimmingCharacters(in: ["'", " "]), nrOfLines: 1)
        UI.fit(titleLabel, to: self.contentView, left: 0, right: 0)
        titleLabel.textColor = .label
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: authorLabel.topAnchor, constant: 0).isActive = true

        backgroundColor = .clear
    }
    
}
