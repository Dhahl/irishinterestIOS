// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit

struct BarItem {
    
    public static func create(title: String, iconName: String, selectedIconName: String) -> UITabBarItem {
        return UITabBarItem(title: title,
                            image: UIImage(systemName: iconName),
                            selectedImage: UIImage(systemName: selectedIconName))
    }
        
}
