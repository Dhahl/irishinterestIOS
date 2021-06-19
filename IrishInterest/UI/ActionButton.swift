// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import QuartzCore

final class ActionButton: UIButton {
    
    public static func create(title: String) -> ActionButton {
        let button = ActionButton(type: .custom)
        button.clipsToBounds = true
        button.setTitle(title, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundColor(Brand.colorPrimary, for: .normal)
        button.setBackgroundColor(Brand.colorPrimary.lighter!, for: .highlighted)
        button.layer.cornerRadius = 15.0
        if let btnLabel: UILabel = button.titleLabel {
            UI.body(label: btnLabel, text: "")
        }
        return button
    }
    
    public func setIsCorrect(_ isCorrect: Bool?) {
        switch isCorrect {
        case true:
            setBackgroundColor(Brand.colorOK, for: .normal)
        case false:
            setBackgroundColor(Brand.colorError, for: .normal)
        default:
            setBackgroundColor(Brand.colorPrimary, for: .normal)
        }
    }
}


extension UIButton {

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(UIImage.from(color), for: state)
    }
    
}

extension UIImage {
    static func from(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
