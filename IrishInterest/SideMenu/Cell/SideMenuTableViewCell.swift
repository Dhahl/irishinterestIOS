//  Created by Balazs Perlaki-Horvath on 21/06/2021.

import Foundation
import UIKit

struct SideMenuModel {
    let icon: UIImage
    let title: String
    let highlights: Bool
    
    init (icon: UIImage, title: String, highlights: Bool = true) {
        self.title = title
        self.icon = icon
        self.highlights = highlights
    }
}

final class SideMenuTableViewCell: UITableViewCell {
    
    public func setup(with model: SideMenuModel) {
        imageView?.image = model.icon
        textLabel?.text = model.title
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        imageView?.tintColor = .white
        textLabel?.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
