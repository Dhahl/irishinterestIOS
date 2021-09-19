// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift

final class AuthorDetailsView: UIView {
    
    private enum Const {
        static let border: CGFloat = 16
        static let imageRatio: CGFloat = 1.0
        static let imageWidthPercent: CGFloat = 0.382
    }
    
    private let details: AuthorDetails
    private let imageView: UIImageView = UIImageView()
    private let title: UILabel = UILabel()
    private let label: UILabel = UILabel()
    private let disposeBag = DisposeBag()
    
    var lastView: UIView {
        label
    }
    
    init(with frame: CGRect, and details: AuthorDetails, imageLoader: ImageLoader) {
        self.details = details
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        

        // TITLE - name
        addSubview(title)
        UI.fit(title, to: self.safeAreaLayoutGuide, left: Const.border, top: Const.border)
        UI.format(.title1, label: title, text: details.author, nrOfLines: 0)
        title.textColor = .label
        
        // IMAGE
        addSubview(imageView)
        imageView.backgroundColor = .tertiarySystemFill
        imageView.contentMode = .scaleAspectFit
        title.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -Const.border).isActive = true
        
        UI.fit(imageView, to: self.safeAreaLayoutGuide, right: Const.border, top: Const.border)
        imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Const.imageWidthPercent).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: Const.imageRatio).isActive = true
        
        imageLoader.load(url: details.imageURL)
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        // TEXT
        addSubview(label)
        UI.fit(label, to: self.safeAreaLayoutGuide, left: Const.border, right: Const.border)
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2*Const.border).isActive = true
        UI.format(.body, label: label, text: details.profile ?? "", nrOfLines: 0)
        label.textColor = .label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
