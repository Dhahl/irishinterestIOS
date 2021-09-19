// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit

class ViewStack {
    weak var view: UIView?
    weak var lastView: UIView?
    let alignFunction: (UIView, UIView, CGFloat) -> Void

    /// - Parameters:
    ///   - parent: view
    ///   - lastView: optional
    ///   - alignFunction: (subView, lastView, constant)
    init(parent: UIView, lastView: UIView?, alignFunction: @escaping (UIView, UIView, CGFloat) -> Void) {
        self.view = parent
        self.lastView = lastView
        self.alignFunction = alignFunction
    }
    
    func add(_ subview: UIView, constant: CGFloat = 8) {
        view?.addSubview(subview)
        if let lastView = self.lastView {
            alignFunction(subview, lastView, constant)
        } else {
            if let view = self.view {
                // the first subView added related to parent
                alignFunction(subview, view, constant)
            }
        }
        lastView = subview
    }
    
    var isEmpty: Bool {
        lastView == nil
    }
}

class HStack: ViewStack {
    init(parent: UIView, lastView: UIView?) {
        super.init(parent: parent, lastView: lastView, alignFunction: UI.rightAlign(_:to:constant:))
    }
}
