// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit

final class HomeTabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Irish Interest"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: ActionButton(type: .infoLight))
    }
}
