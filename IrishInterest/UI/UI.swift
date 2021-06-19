// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit

struct UI {
    
    static func body(label: UILabel, text: String = "", nrOfLines: Int = 0) {
        format(.body,
               label: label, text: text, nrOfLines: nrOfLines)
    }
    
    static func headline(label: UILabel, text: String = "", nrOfLines: Int = 0) {
        format(.headline,
               label: label, text: text, nrOfLines: nrOfLines)
    }
    
    static func title3(label: UILabel, text: String = "", nrOfLines: Int = 0) {
        format(.title3,
               label: label, text: text, nrOfLines: nrOfLines)
    }
    
    static func title2(label: UILabel, text: String = "", nrOfLines: Int = 0) {
        format(.title2,
               label: label, text: text, nrOfLines: nrOfLines)
    }
    
    static func caption1(label: UILabel, text: String = "", nrOfLines: Int = 0) {
        format(.caption1,
               color: UIColor(red: 0.922, green: 0.922, blue: 0.961, alpha: 0.6),
               label: label, text: text, nrOfLines: nrOfLines)
    }
    
    static func format(_ textStyle: UIFont.TextStyle, color: UIColor = .white,
                               label: UILabel, text: String, nrOfLines: Int) {
        label.text = text
        label.textColor = color
        label.font = UIFont.preferredFont(forTextStyle: textStyle)
        label.numberOfLines = nrOfLines
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        label.allowsDefaultTighteningForTruncation = true
        label.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        label.sizeToFit()
    }
    
    static func fit(_ subView: UIView, to parent: UIView,
                    left: CGFloat? = nil, right: CGFloat? = nil,
                    bottom: CGFloat? = nil, top: CGFloat? = nil,
                    width: CGFloat? = nil, height: CGFloat? = nil) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(subView)
        if let left = left {
            subView.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: left).isActive = true
        }
        if let right = right {
            subView.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: 0 - right).isActive = true
        }
        if let top = top {
            subView.topAnchor.constraint(equalTo: parent.topAnchor, constant: top).isActive = true
        }
        if let bottom = bottom {
            subView.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: 0 - bottom).isActive = true
        }
        if let width = width {
            subView.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            subView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    static func fit(_ subView: UIView, to parent: UILayoutGuide,
                    left: CGFloat? = nil, right: CGFloat? = nil,
                    bottom: CGFloat? = nil, top: CGFloat? = nil,
                    width: CGFloat? = nil, height: CGFloat? = nil) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        if let left = left {
            subView.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: left).isActive = true
        }
        if let right = right {
            subView.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: 0 - right).isActive = true
        }
        if let top = top {
            subView.topAnchor.constraint(equalTo: parent.topAnchor, constant: top).isActive = true
        }
        if let bottom = bottom {
            subView.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: 0 - bottom).isActive = true
        }
        if let width = width {
            subView.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            subView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    static func vAlign(_ subView: UIView, below view: UIView, constant: CGFloat = 0.0) {
        subView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: constant).isActive = true
    }
    
    static func rightAlign(_ subView: UIView, to view: UIView, constant: CGFloat = 0.0) {
        subView.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant).isActive = true
    }

}
