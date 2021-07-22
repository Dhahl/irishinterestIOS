// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift

final class SearchViewController: UIViewController, SearchResultsObservable {
    
    private var disposeBag = DisposeBag()
    var searchBar: UISearchBar {
        navigationItem.searchController?.searchBar ?? UISearchBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = UISearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSearchBar(withPlaceholder: "Books or Authors")
        searchTextObservable
            .subscribe(onNext: { (searchValue: String?) in
                guard let value = searchValue, !value.isEmpty else {
                    //clear search result
                    return
                }
                print("searching general: \(value)")
            })
            .disposed(by: disposeBag)
    }
  
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
}
