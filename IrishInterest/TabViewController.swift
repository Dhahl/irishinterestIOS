// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit

final class TabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Irish Interest"
        view.backgroundColor = .white
        let burgerImage = UIImage(systemName: "line.horizontal.3")
        let barButton = UIBarButtonItem(image: burgerImage, style: .plain, target: nil, action: nil)
        barButton.tintColor = Brand.colorTabSelected
        navigationItem.rightBarButtonItem = barButton
        
        tabBar.backgroundColor = Brand.colorTabBarBackground
        tabBar.unselectedItemTintColor = Brand.colorTabUnselected
        tabBar.tintColor = Brand.colorTabSelected
    }
}
