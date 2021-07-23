// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit

struct TitleLabel {
    let titleText: String
    let valueText: String
    
    func display(in contentView: UIView, with stack: VStack, using border: CGFloat) {
        let title = UILabel()
        let value = UILabel()
        UI.format(.body, color: .label, label: title, text: titleText, nrOfLines: 1)
        UI.format(.body, color: .label, label: value, text: valueText, nrOfLines: 1)
        UI.fit(title, to: contentView, left: border)
        title.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -border).isActive = true
        UI.fit(value, to: contentView, left: border)
        value.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -border).isActive = true
        stack.add(title, constant: border)
        stack.add(value, constant: 0)
    }
}
