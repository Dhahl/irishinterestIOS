//  Created by Balazs Perlaki-Horvath on 24/06/2021.


import Foundation
import UIKit

final class SideMenuController: NSObject, UIGestureRecognizerDelegate {
    public private(set) var isOpen: Bool = false {
        didSet {
            if isOpen != oldValue { //distinct until changed
                didUpdate(isOpen)
            }
        }
    }
    private weak var view: UIView?
    private weak var sideMenuView: UIView?
    private let didUpdate: (Bool) -> Void
    
    public init(setUpFor view: UIView, sideMenuView: UIView, didUpdate: @escaping (Bool) -> Void) {
        self.view = view
        self.sideMenuView = sideMenuView
        self.didUpdate = didUpdate
        super.init()
        
        // Tap Gestures
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // On pressing the button
    public func toggle() {
        isOpen = !isOpen
    }
    
    // Tapping
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            isOpen = false
        }
    }
    
    // Only recieve touches that are outside of the side menu
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let sideMenu = sideMenuView {
            return touch.view?.isDescendant(of: sideMenu) == false
        }
        return false //unlikely case of no longer having a reference to the sideMenu
    }
}
