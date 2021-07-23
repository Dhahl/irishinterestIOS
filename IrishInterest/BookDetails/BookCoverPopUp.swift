// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit

final class BookCoverPopUp: UIViewController {
    
    private let imageView = UIImageView()

    func display(image: UIImage?) {
        imageView.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = .scaleAspectFit
        UI.fit(imageView, to: view, left: 0, right: 0, bottom: 0, top: 0)
    }
}
