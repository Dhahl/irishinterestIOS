// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift

struct TextContent {
    let title: String
    let description: Observable<String>
    let tapRecognizer: UITapGestureRecognizer?
    
    init(title: String, description: Observable<String>, tapRecognizer: UITapGestureRecognizer? = nil) {
        self.title = title
        self.description = description
        self.tapRecognizer = tapRecognizer
    }
}

final class TextContentUIViewController: UIViewController {
    
    private var navTitle: String?
    private var contents: [TextContent] = []
    private let disposeBag = DisposeBag()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var safeArea: UILayoutGuide {
        contentView.safeAreaLayoutGuide
    }
    
    private enum Const {
        static let border: CGFloat = 16
    }
    
    func setup(title: String, contents: [TextContent]) {
        self.navTitle = title
        self.contents = contents
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        
        //Scroll view
        view.addSubview(scrollView)
        UI.fit(scrollView, to: view.safeAreaLayoutGuide, left: 0, right: 0, bottom: 0, top: 0)
        scrollView.addSubview(contentView)
        contentView.backgroundColor = .systemBackground
        UI.fit(contentView, to: scrollView, left: 0, right: 0, bottom: 0, top: 0)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor).isActive = true

        setLogoAsNavItem()
        
        let vStack = VStack(parent: contentView, lastView: nil)
        
        contents.forEach { (content: TextContent) in
            let isFirst = vStack.isEmpty
            
            // title
            let titleLabel = UILabel()
            vStack.add(titleLabel, constant: Const.border)
            UI.format(.title1, label: titleLabel, text: content.title, nrOfLines: 0)
            if isFirst {
                // constraint first view to top, to be able to scroll
                UI.fit(titleLabel, to: safeArea, left: Const.border, right: Const.border, top: Const.border)
            } else {
                UI.fit(titleLabel, to: safeArea, left: Const.border, right: Const.border)
            }
            titleLabel.textColor = .label
            
            // content
            let contentLabel = UILabel()
            vStack.add(contentLabel, constant: Const.border)
            UI.fit(contentLabel, to: safeArea, left: Const.border, right: Const.border)
            UI.format(.body, label: contentLabel, text: "", nrOfLines: 0)
            contentLabel.textColor = .label
            if let tapRecognizer = content.tapRecognizer {
                contentLabel.textColor = .link
                contentLabel.isUserInteractionEnabled = true
                contentLabel.addGestureRecognizer(tapRecognizer)
            }
            
            content.description.observe(on: MainScheduler.instance)
                .doLoading(with: Loader(view: contentLabel))
                .subscribe { (contentText: String) in
                    contentLabel.text = contentText
                }.disposed(by: disposeBag)
            
            //bind the lastView's bottom to the contentView bottom to make it scrollable:
            if let lastView = vStack.lastView {
                let bottomConstraint = lastView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -7*Const.border)
                bottomConstraint.priority = .defaultLow
                bottomConstraint.isActive = true
            }
        }
        
    }
    
    func setupTitle() {
        if let navTitle = navTitle {
            navigationItem.title = navTitle
        }
    }
    
    func setLogoAsNavItem() {
        let logoImage = UIImage(named: "logo")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit
        let rightButtonItem = UIBarButtonItem(customView: logoImageView)
        navigationItem.rightBarButtonItem = rightButtonItem
        logoImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
    }
}
