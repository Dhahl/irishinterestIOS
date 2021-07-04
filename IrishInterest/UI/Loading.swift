// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift

struct Loading {
    
    private var loading = UIActivityIndicatorView(style: .large)
    
    init(view: UIView) {
        loading.color = Brand.colorLoading
        stopLoading()
        UI.fit(loading, to: view)
        loading.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func subscribe(to observable: Observable<Any>) -> Observable<Any> {
        observable
            .observe(on: MainScheduler.instance)
            .do(afterCompleted: { [self] in self.stopLoading() }, onSubscribed: { [self] in self.startLoading() })
    }
    
    func startLoading() {
        loading.startAnimating()
        loading.isHidden = false
    }
    
    func stopLoading() {
        loading.stopAnimating()
        loading.isHidden = true
    }
}
