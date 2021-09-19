// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit

final class AuthorCoverPopUp: UIViewController {
    
    private enum Const {
        static let border: CGFloat = 16.0
    }
    
    private let scrollView = UIScrollView()
    private var detailsView: AuthorDetailsView?

    func display(detailsView: AuthorDetailsView) {
        self.detailsView = detailsView
        setUp(detailsView: detailsView, in: view)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        if let detailsView = self.detailsView {
            setUp(detailsView: detailsView, in: view)
        }
    }
    
    private func setUp(detailsView: AuthorDetailsView, in view: UIView) {
        
        //Scroll view
        view.addSubview(scrollView)
        UI.fit(scrollView, to: view.safeAreaLayoutGuide, left: 0, right: 0, bottom: Const.border, top: Const.border)
        scrollView.addSubview(detailsView)
        UI.fit(detailsView, to: scrollView, left: 0, right: 0, top: 0)
        detailsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        detailsView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor).isActive = true
        
        //bind the lastView's bottom to the contentView bottom to make it scrollable:
        let bottomConstraint = detailsView.lastView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Const.border)
        bottomConstraint.priority = .defaultLow
        bottomConstraint.isActive = true
    }
}
