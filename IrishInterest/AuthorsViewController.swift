// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class AuthorsViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    private var webService: WebService!
    private var tableView: UITableView = UITableView()
    
    func setup(webService: WebService) {
        self.webService = webService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AuthorsViewController")
        UI.fit(tableView, to: view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("AuthorsViewController.viewDidAppear")
        (tabBarController as? SearchResultsObservable)?.searchTextObservable?
            .subscribe(onNext: { (searchValue: String?) in
                guard let value = searchValue, !value.isEmpty else {
                    //clear search result
                    return
                }
                print("searching for Author: \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
}
