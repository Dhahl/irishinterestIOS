// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift

final class DetailsViewController: UIViewController {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let imageLoader = ImageLoader()
    
    private let disposeBag = DisposeBag()
    private var book: Book?
    private var webservice: WebService?
    
    private enum Const {
        static let border: CGFloat = 16
        static let imageWidthPercent: CGFloat = 0.56
        static let imageRatio: CGFloat = 1.5
    }
    
    func bind(model: Book, webservice: WebService) {
        self.book = model
        self.webservice = webservice
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let stack = VStack(parent: view, lastView: nil)
        
        // IMAGE
        view.addSubview(imageView)
        UI.fit(imageView, to: view.safeAreaLayoutGuide, top: Const.border)
        imageView.backgroundColor = .tertiarySystemFill
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Const.imageWidthPercent).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: Const.imageRatio).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        if let book = book {
            imageLoader.load(url: book.imageURL)
                .bind(to: imageView.rx.image)
                .disposed(by: disposeBag)
        }
        stack.add(imageView)
        
        // TITLE
        let titleText: String = book?.displayTitle ?? ""
        UI.format(.title2, label: titleLabel, text: titleText, nrOfLines: 2)
        titleLabel.textColor = .label
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.textAlignment = .center
        UI.fit(titleLabel, to: view, left: Const.border, right: Const.border)
        stack.add(titleLabel, constant: Const.border)
        
        // AUTHOR
        UI.format(.subheadline, label: authorLabel, text: book?.author ?? "", nrOfLines: 1)
        authorLabel.textColor = .secondaryLabel
        authorLabel.adjustsFontSizeToFitWidth = false
        authorLabel.textAlignment = .center
        UI.fit(authorLabel, to: view, left: Const.border, right: Const.border)
        stack.add(authorLabel)
        
        // DETAILS
        if let book = book {
            webservice?.details(bookID: book.id)
                .observe(on: MainScheduler.instance)
                .doLoading(with: Loader(view: view))
                .subscribe(onNext: { [weak self] (details: BookDetails) in
                    guard let strongSelf = self else { return }
                    if let vendor = details.vendor, vendor.lowercased().contains("amazon") {
                        // BUY AT AMAZON
                        let actionButton = ActionButton.create(title: "Buy at Amazon")
                        UI.fit(actionButton, to: strongSelf.view, right: Const.border, width: Const.border * 12.7, height: Const.border * 3)
                        stack.add(actionButton, constant: Const.border)
                        //TODO: set up amazon link
                    }
                    // Description / synopsis
                    UI.fit(strongSelf.descriptionLabel, to: strongSelf.view, left: Const.border, right: Const.border)
                    stack.add(strongSelf.descriptionLabel, constant: Const.border)
                    UI.format(.body, label: strongSelf.descriptionLabel, text: details.synopsis, nrOfLines: 0)
                    strongSelf.descriptionLabel.textAlignment = .justified
                    strongSelf.descriptionLabel.textColor = .label
                })
                .disposed(by: disposeBag)
        }
    }
}

