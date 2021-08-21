// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift

final class DetailsViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let imageLoader = ImageLoader()
    
    private let disposeBag = DisposeBag()
    private var book: Book?
    private var webservice: WebService?
    
    private var details: BookDetails?
    
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
        
        //Scroll view
        view.addSubview(scrollView)
        UI.fit(scrollView, to: view.safeAreaLayoutGuide, left: 0, right: 0, bottom: 0, top: 0)
        scrollView.addSubview(contentView)
        UI.fit(contentView, to: scrollView, left: 0, right: 0, bottom: 0, top: 0)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor).isActive = true
        
        let stack = VStack(parent: contentView, lastView: nil)
        
        // IMAGE
        contentView.addSubview(imageView)
        UI.fit(imageView, to: contentView.safeAreaLayoutGuide, top: Const.border)
        imageView.backgroundColor = .tertiarySystemFill
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: Const.imageWidthPercent).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: Const.imageRatio).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        if let book = book {
            imageLoader.load(url: book.imageURL)
                .bind(to: imageView.rx.image)
                .disposed(by: disposeBag)
        }
        stack.add(imageView)
        bindImageTaps()
        
        // TITLE
        let titleText: String = book?.displayTitle ?? ""
        UI.format(.title2, label: titleLabel, text: titleText, nrOfLines: 2)
        titleLabel.textColor = .label
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.textAlignment = .center
        UI.fit(titleLabel, to: contentView, left: Const.border, right: Const.border)
        stack.add(titleLabel, constant: Const.border)
        
        // AUTHOR
        UI.format(.subheadline, label: authorLabel, text: book?.author ?? "", nrOfLines: 1)
        authorLabel.textColor = .secondaryLabel
        authorLabel.adjustsFontSizeToFitWidth = false
        authorLabel.textAlignment = .center
        UI.fit(authorLabel, to: contentView, left: Const.border, right: Const.border)
        stack.add(authorLabel)
        
        // DETAILS
        if let book = book {
            webservice?.details(bookID: book.id)
                .observe(on: MainScheduler.instance)
                .doLoading(with: Loader(view: contentView))
                .subscribe(onNext: { [weak self] (details: BookDetails) in
                    guard let strongSelf = self else { return }
                    strongSelf.bindDetails(details: details, stack: stack)
                })
                .disposed(by: disposeBag)
        }
    }
    
    @objc func openInBrowser() {
        if let url = URL(string: details?.vendorurl ?? "") {
            UIApplication.shared.open(url)
        }
    }
    
    private func bindDetails(details: BookDetails, stack: VStack) {
        self.details = details
        // BUY AT AMAZON
        if let vendor = details.vendor,
           vendor.lowercased().contains("amazon"),
           let _ = URL(string: details.vendorurl ?? "") {
            let actionButton = ActionButton.create(title: "Buy at Amazon")
            UI.fit(actionButton, to: contentView, right: Const.border, width: Const.border * 12.7, height: Const.border * 3)
            stack.add(actionButton, constant: Const.border)
            actionButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openInBrowser)))
        }
        
        //Publisher info:
        if !details.publisher.isEmpty {
            TitleLabel(titleText: "Publisher", valueText: details.publisher)
                .display(in: contentView, with: stack, using: Const.border)
        }
        
        if !details.isbnToDisplay.isEmpty {
            TitleLabel(titleText: "ISBN", valueText: details.isbnToDisplay)
                .display(in: contentView, with: stack, using: Const.border)
        }
        
        // Description / synopsis
        UI.fit(descriptionLabel, to: contentView, left: Const.border, right: Const.border)
        stack.add(descriptionLabel, constant: Const.border)
        UI.format(.body, color: .label, label: descriptionLabel, text: details.synopsisToDisplay, nrOfLines: 0)
        descriptionLabel.textAlignment = .left
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        //bind the lastView's bottom to the contentView bottom to make it scrollable:
        if let lastView = stack.lastView {
            let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: lastView.bottomAnchor, constant: Const.border)
            bottomConstraint.priority = .defaultLow
            bottomConstraint.isActive = true
        }
    }
    
    private func bindImageTaps() {
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer( UITapGestureRecognizer.init(target: self,
                                                                    action: #selector(onImageTap)))
    }
    
    @objc func onImageTap() {
        let popUp = BookCoverPopUp()
        popUp.display(image: imageView.image)
        present(popUp, animated: true, completion: nil)
    }
}

