// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit

final class FavouritesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.title = "Favourites"
    }
}
