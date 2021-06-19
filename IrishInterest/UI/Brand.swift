// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit.UIColor

enum Brand {
    static let colorPrimary = UIColor.colorFromRGB(0x0094f1)
    static let colorError = UIColor.colorFromRGB(0xd83232)
    static let colorOK = UIColor.colorFromRGB(0x379A49)
    static let colorComplete = UIColor.colorFromRGB(0x9acd32)
    static let colorCellSelectedBackground = UIColor.colorFromRGB(0xE5E5E5, alpha: 0.15)
    static let colorCellHighlightedBackground = UIColor.colorFromRGB(0xFAFAFA, alpha: 0.25)
    static let colorCellBorder = UIColor.init(white: 1.0, alpha: 0.2).cgColor
    static let colorCellBackground = UIColor.init(white: 1.0, alpha: 0.1)
}
