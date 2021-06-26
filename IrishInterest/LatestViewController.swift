// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class LatestViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LatestViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("LatestViewController")
        (tabBarController as? SearchResultsObservable)?.searchTextObservable?
            .subscribe(onNext: { (searchValue: String?) in
                guard let value = searchValue, !value.isEmpty else {
                    //clear search result
                    print("clear")
                    return
                }
                print("searching for Latest: \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
}
