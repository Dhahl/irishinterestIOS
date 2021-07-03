// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift

protocol SearchResultsObservable {
    var searchBar: UISearchBar { get }
    var navigationItem: UINavigationItem { get }
    func hideSearchBar()
}
extension SearchResultsObservable {
    var searchTextObservable: Observable<String?> {
        searchBar.rx.text
            .subscribe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .debounce( RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
    }
    
    func showSearchBar(withPlaceholder placeholder: String) {
        searchBar.placeholder = placeholder
        navigationItem.titleView = searchBar
    }
}

final class TabViewController: UITabBarController, SearchResultsObservable {
    
    let searchBar = UISearchBar()
    let logoImageView = UIImageView(image: UIImage(named: "logo"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
//        hideSearchBar()
        
        // NAV LEFT
        let burgerImage = UIImage(systemName: "line.horizontal.3")
        let barButton = UIBarButtonItem(image: burgerImage, style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = barButton
    }
    
    public func hideSearchBar() {
        logoImageView.contentMode = .scaleAspectFit
        let barTitleView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.65, height: 22))
        logoImageView.frame = barTitleView.frame
        barTitleView.addSubview(logoImageView)
        navigationItem.titleView = barTitleView
    }
}
