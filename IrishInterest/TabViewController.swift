// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift

protocol SearchResultsObservable {
    var searchTextObservable: Observable<String?>? { get }
}

final class TabViewController: UITabBarController, SearchResultsObservable {
    
    var searchTextObservable: Observable<String?>? {
        get {
            navigationItem.searchController?.searchBar.rx.text
                .subscribe(on: MainScheduler.instance)
                .distinctUntilChanged()
                .debounce( RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let logoView = UIImageView(image: UIImage(named: "logo"))
        logoView.contentMode = .scaleAspectFit
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.65, height: 22))
        logoView.frame = view.frame
        view.addSubview(logoView)
        navigationItem.titleView = view
        
        // NAV LEFT
        let burgerImage = UIImage(systemName: "line.horizontal.3")
        let barButton = UIBarButtonItem(image: burgerImage, style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = barButton
    }
}
