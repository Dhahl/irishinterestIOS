// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift

protocol SearchResultsObservable {
    var searchBar: UISearchBar { get }
    var navigationItem: UINavigationItem { get }
}
extension SearchResultsObservable {
    var searchTextObservable: Observable<String> {
        searchBar.rx.text.orEmpty
            .subscribe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .debounce( RxTimeInterval.milliseconds(150), scheduler: MainScheduler.instance)
    }
    
    func showSearchBar(withPlaceholder placeholder: String) {
        searchBar.placeholder = placeholder
        navigationItem.titleView = searchBar
    }
}

final class TabViewController: UITabBarController {
    
    let logoImageView = UIImageView(image: UIImage(named: "logo"))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // NAV LEFT
//        let burgerImage = UIImage(systemName: "line.horizontal.3")
//        let barButton = UIBarButtonItem(image: burgerImage, style: .plain, target: nil, action: nil)
//        navigationItem.rightBarButtonItem = barButton
    }
    
//    public func hideSearchBar() {
//        logoImageView.contentMode = .scaleAspectFit
//        let barTitleView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.65, height: 22))
//        logoImageView.frame = barTitleView.frame
//        barTitleView.addSubview(logoImageView)
//        navigationItem.titleView = barTitleView
//    }
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//    }
    
}
