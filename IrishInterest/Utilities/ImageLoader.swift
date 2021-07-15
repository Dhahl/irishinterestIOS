// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift

struct ImageLoader {
    
    let fallbackImage: UIImage = UIImage(named: "logo_g2_cut")!.image(alpha: 0.03, blendMode: .screen)!
    let scheduler: SerialDispatchQueueScheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "imageLoader")
    
    func load(url: URL?) -> Observable<UIImage?> {
        guard let url = url else {
            return .just(fallbackImage)
        }
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { (data: Data) -> UIImage? in
                UIImage(data: data)
            }
            .subscribe(on: scheduler)
            .observe(on: MainScheduler.instance)
    }
}

extension UIImage {
    func image(alpha: CGFloat, blendMode: CGBlendMode = .normal) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: blendMode, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
