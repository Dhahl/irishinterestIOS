// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit

final class TabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Irish Interest"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: ActionButton(type: .infoLight))
        
        tabBar.backgroundColor = Brand.colorTabBarBackground
        tabBar.unselectedItemTintColor = Brand.colorTabUnselected
        tabBar.tintColor = Brand.colorTabSelected
    }
}
