// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift


struct Loader: Loading {
    
    private var loading = UIActivityIndicatorView(style: .large)
    
    init(view: UIView) {
        loading.color = Brand.colorLoading
        stop()
        UI.fit(loading, to: view)
        loading.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func start() {
        DispatchAsyncIfMain {
            loading.startAnimating()
            loading.isHidden = false
        }
    }
    
    func stop() {
        DispatchAsyncIfMain {
            loading.stopAnimating()
            loading.isHidden = true
        }
    }
}

public protocol Loading {
    func start()
    func stop()
}

extension ObservableType {
    public func doLoading(with loading: Loading) -> Observable<Element> {
            self.do(onNext: { [loading] _ in loading.stop() },
                    onError: { [loading] _ in loading.stop() },
                    onSubscribe: { [loading] in loading.start() },
                    onDispose: { [loading] in loading.stop() }
            )
    }
}
