// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit

final class ContactUsViewController: UIViewController {
    
    var service: WebService!
    var navTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = navTitle
    }
    
    func setup(title: String, service: WebService) {
        self.navTitle = title
        self.service = service
    }
}
