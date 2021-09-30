// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift

final class DetailsViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private var authorLabels: [UILabel] = []
    private let descriptionLabel = UILabel()
    private let imageLoader = ImageLoader()
    private let favouriteImageView = UIImageView(image: UIImage(systemName: "star"))
    
    private let disposeBag = DisposeBag()
    private var book: Book?
    private var authors: [Author] = []
    private var webservice: WebService?
    private var favouriteService: FavouriteService?
    private var bookDetails: BookDetails?
    private var authorDetails: [Int: AuthorDetails] = [:]
    private var onAuthorSelected: ((Int) -> Void)?
    
    private enum Const {
        static let border: CGFloat = 16
        static let socialSize: CGFloat = 40
        static let favIconSize: CGFloat = 48
        static let imageWidthPercent: CGFloat = 0.56
        static let imageRatio: CGFloat = 1.5
    }
    
    func bind(model: Book,
              authors: [Author],
              webservice: WebService,
              favouriteService: FavouriteService,
              onAuthorSelected: ((Int) -> Void)?) {
        self.book = model
        self.authors = authors
        self.webservice = webservice
        self.favouriteService = favouriteService
        self.onAuthorSelected = onAuthorSelected
        favouriteService.isFavourite(book: model).map({ (isFav: Bool) -> UIImage? in
            isFav ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        }).bind(to: favouriteImageView.rx.image).disposed(by: disposeBag)
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
        
        // FAVOURITE
        favouriteImageView.contentMode = .scaleAspectFit
        UI.fit(favouriteImageView, to: contentView, width: Const.favIconSize, height: Const.favIconSize)
        favouriteImageView.centerXAnchor.constraint(equalTo: imageView.rightAnchor).isActive = true
        favouriteImageView.centerYAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        favouriteImageView.isUserInteractionEnabled = true
        favouriteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleFavouriteBook)))
        
        // TITLE
        let titleText: String = book?.displayTitle ?? ""
        UI.format(.title2, label: titleLabel, text: titleText, nrOfLines: 2)
        titleLabel.textColor = .label
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.textAlignment = .center
        UI.fit(titleLabel, to: contentView, left: Const.border, right: Const.border)
        stack.add(titleLabel, constant: Const.border)
        
        // AUTHORS
        resetAuthorLabels()
        for author in authors {
            let authorLabel = UILabel()
            UI.format(.subheadline, label: authorLabel, text: author.displayName, nrOfLines: 1)
            authorLabel.textColor = .secondaryLabel
            authorLabel.adjustsFontSizeToFitWidth = false
            authorLabel.textAlignment = .center
            UI.fit(authorLabel, to: contentView, left: Const.border, right: Const.border)
            stack.add(authorLabel)
            if author.id != 0 {
                webservice?.authorDetails(authorId: author.id)
                    .observe(on: MainScheduler.instance)
                    .doLoading(with: Loader(view: contentView))
                    .subscribe(onNext: { [weak self] (details: AuthorDetails) in
                        self?.bind(authorDetails: details, authorId: author.id, to: authorLabel)
                    })
                    .disposed(by: disposeBag)
            }
        }
        
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
    
    private func bind(authorDetails: AuthorDetails, authorId: Int, to authorLabel: UILabel) {
        self.authorDetails[authorId] = authorDetails // !important
        if authorDetails.isWorthToShow {
            authorLabel.textColor = Brand.colorPrimary
            authorLabel.isUserInteractionEnabled = true
            let recognizer = AuthorDetailTapRecognizer(target: self, action: #selector(onAuthorTapped))
            recognizer.authorId = authorId
            authorLabel.addGestureRecognizer(recognizer)
        }
    }
    
    private func resetAuthorLabels() {
        for label in authorLabels {
            label.removeFromSuperview()
        }
        authorLabels = []
    }
    
    @objc func onAuthorTapped(recognizer: AuthorDetailTapRecognizer) {
        if recognizer.authorId != 0 {
            onAuthorSelected?(recognizer.authorId)
        }
        showAuthorProfile(recognizer.authorId)
    }
    
    @objc func toggleFavouriteBook() {
        if let book = book {
            favouriteService?.toggle(book: book)
        }
    }
    
    private func bindDetails(details: BookDetails, stack: VStack) {
        self.bookDetails = details // !important
        addActionButtons(details: details, stack: stack)
        addShareButton()
        
        //Publisher info:
        if !details.publisher.isEmpty {
            TitleLabel(titleText: "Publisher", valueText: details.publisher)
                .display(in: contentView, with: stack, using: Const.border)
        }
        
        if !details.isbnToDisplay.isEmpty {
            TitleLabel(titleText: "ISBN", valueText: details.isbnToDisplay)
                .display(in: contentView, with: stack, using: Const.border)
        }
        
        if let publishedDate = details.published {
            TitleLabel(titleText: "Published", valueText: publishedDate)
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
    
    // MARK: author profile pop-up
    func showAuthorProfile(_ authorId: Int) {
        guard let authorDetails = self.authorDetails[authorId] else { return }
        let popUp = AuthorCoverPopUp()
        popUp.display(detailsView: AuthorDetailsView(with: self.view.frame, and: authorDetails, imageLoader: ImageLoader()))
        navigationController?.present(popUp, animated: true, completion: nil)
    }
    
    // MARK: image pop-up
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
    
    // MARK: social buttons
    private func addActionButtons(details: BookDetails, stack: VStack) {
        // Action buttons content view as a row
        let actionsView = UIView()
        UI.fit(actionsView, to: contentView, left: Const.border, right: 0, height: Const.socialSize)
        stack.add(actionsView)
        
        let topMargin: CGFloat = 4.0
        
        //FACEBOOK
        let facebookButton = ActionButton.createSquaredImage(name: "facebook", size: Const.socialSize)
        UI.fit(facebookButton, to: actionsView, left: 0, top: topMargin, width: Const.socialSize, height: Const.socialSize)
        facebookButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openFacebook)))
        
        //TWITTER
        let twitterButton = ActionButton.createSquaredImage(name: "twitter", size: Const.socialSize)
        UI.fit(twitterButton, to: actionsView, left: Const.socialSize, top: topMargin, width: Const.socialSize, height: Const.socialSize)
        twitterButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openTwitter)))
        
        //INSTAGRAM
        let instagramButton = ActionButton.createSquaredImage(name: "instagram", size: Const.socialSize)
        UI.fit(instagramButton, to: actionsView, left: 2 * Const.socialSize, top: topMargin, width: Const.socialSize, height: Const.socialSize)
        instagramButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openInstagram)))
        
        //YOUTUBE
        let youtubeButton = ActionButton.createSquaredImage(name: "youtube", size: Const.socialSize)
        UI.fit(youtubeButton, to: actionsView, left: 3 * Const.socialSize, top: topMargin, width: Const.socialSize, height: Const.socialSize)
        youtubeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openYoutube)))
        
        // BUY AT AMAZON
        if let vendor = details.vendor,
           vendor.lowercased().contains("amazon"),
           let _ = URL(string: details.vendorurl ?? "") {
            let amazonButton = ActionButton.create(title: "Buy at Amazon")
            UI.fit(amazonButton, to: actionsView, right: Const.border, top: 0, width: Const.border * 10, height: Const.border * 3)
            amazonButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAmazon)))
        }
    }
    
    private func addShareButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(share(_:)))
    }
    
    @objc private func share(_ sender: UIBarButtonItem) {
        guard let bookDetails = bookDetails else {
            return
        }
        let itemsToShare: [Any]
        if let image = imageView.image {
            itemsToShare = [bookDetails.textToShare, bookDetails.linkToShare, image]
        } else {
            itemsToShare = [bookDetails.textToShare, bookDetails.linkToShare]
        }
        let activityViewController = UIActivityViewController(activityItems: itemsToShare,
                                                              applicationActivities: nil)
        activityViewController.excludedActivityTypes = [
            .addToReadingList,
            .airDrop,
            .assignToContact,
            .print,
            .saveToCameraRoll,
            .openInIBooks,
        ]
        if UIDevice.current.userInterfaceIdiom == .pad {
            if activityViewController.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                activityViewController.popoverPresentationController?.barButtonItem = sender
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func openAmazon() {
        if let url = URL(string: bookDetails?.vendorurl ?? "") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func openFacebook() {
        if let url = bookDetails?.facebookURL { UIApplication.shared.open(url) }
    }
    
    @objc func openTwitter() {
        if let url = bookDetails?.twitterURL { UIApplication.shared.open(url) }
    }
    
    @objc func openYoutube() {
        if let url = bookDetails?.youtubeURL { UIApplication.shared.open(url) }
    }
    
    @objc func openInstagram() {
        if let url = bookDetails?.instagramURL { UIApplication.shared.open(url) }
    }
    
}

