//  Created by Balazs Perlaki-Horvath on 23/06/2021.

import Foundation
import UIKit

final class SideMenuHeader: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let superview = superview {
            leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: 50).isActive = true
        
            let logoImage = UIImageView(image: UIImage(named: "logo"))
            logoImage.translatesAutoresizingMaskIntoConstraints = false
            addSubview(logoImage)
            logoImage.contentMode = ContentMode.scaleAspectFit
            logoImage.leadingAnchor.constraint(equalTo:  superview.leadingAnchor, constant: 16).isActive = true
            logoImage.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -16).isActive = true
            logoImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
