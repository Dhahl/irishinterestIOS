// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit

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
