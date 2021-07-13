// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit

final class BookViewCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    let separator = UIView()
    
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
        UI.body(label: titleLabel, text: book.title, nrOfLines: 1)
        UI.fit(titleLabel, to: self.contentView, left: 16, right: 16)
        titleLabel.textColor = .label
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        
        UI.fit(separator, to: self.contentView, left: 16, right: 16, bottom: 0)
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.backgroundColor = .systemFill
    }
    
}
