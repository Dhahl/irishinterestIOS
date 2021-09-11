// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit

class VStack {
    weak var view: UIView?
    weak var lastView: UIView?
    
    init(parent: UIView, lastView: UIView?) {
        self.view = parent
        self.lastView = lastView
    }
    
    func add(_ subview: UIView, constant: CGFloat = 8) {
        view?.addSubview(subview)
        if let lastView = self.lastView {
            UI.vAlign(subview, below: lastView, constant: constant)
        }
        lastView = subview
    }
    
    var isEmpty: Bool {
        lastView == nil
    }
}

