// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit

final class TextViewCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    
    public override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                selectedBackgroundView?.backgroundColor = Brand.colorCellHighlightedBackground
            } else {
                selectedBackgroundView?.backgroundColor = Brand.colorCellSelectedBackground
            }
        }
    }
    
    func update(title: String) {
        UI.body(label: titleLabel, text: title, nrOfLines: 1)
        UI.fit(titleLabel, to: self.contentView, left: 16, right: 16)
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
    }
    
}
