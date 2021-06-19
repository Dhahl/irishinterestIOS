// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit

struct TabBarItem {
    
    public static func create(systemIcon: UITabBarItem.SystemItem, tag: Int) -> UITabBarItem {
        let item = UITabBarItem(tabBarSystemItem: systemIcon, tag: tag)
        item.badgeColor = Brand.colorPrimary
        return item
    }
    
}
