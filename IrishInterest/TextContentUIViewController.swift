// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift

final class TextContentUIViewController: UIViewController {
    
    private let textLabel = UILabel()
    private var navTitle: String?
    private var webService: WebService!
    
    private enum Const {
        static let border: CGFloat = 16
    }
    
    func setup(title: String, webService: WebService) {
        self.navTitle = title
        self.webService = webService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTitle()
        
        view.addSubview(textLabel)
        UI.fit(textLabel, to: view.safeAreaLayoutGuide, left: Const.border, right: Const.border, top: Const.border)
        textLabel.textAlignment = .left
        textLabel.lineBreakMode = .byWordWrapping
        
        UI.format(.body, color: .label, label: textLabel, text: "Terms and conditions", nrOfLines: 0)
    }
    
    func setupTitle() {
        if let navTitle = navTitle {
            navigationItem.title = navTitle
        }
    }
}
