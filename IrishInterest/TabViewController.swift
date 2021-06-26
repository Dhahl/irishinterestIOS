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
        title = "IrishInterest"

        view.backgroundColor = .white
        
        // NAV LEFT
        let burgerImage = UIImage(systemName: "line.horizontal.3")
        let barButton = UIBarButtonItem(image: burgerImage, style: .plain, target: nil, action: nil)
        barButton.tintColor = Brand.colorTabSelected
        navigationItem.rightBarButtonItem = barButton
        
        // TAB BAR
        tabBar.backgroundColor = Brand.colorTabBarBackground
        tabBar.unselectedItemTintColor = Brand.colorTabUnselected
        tabBar.tintColor = Brand.colorTabSelected
    }
}
