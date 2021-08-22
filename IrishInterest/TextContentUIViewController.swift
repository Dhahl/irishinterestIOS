// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import UIKit
import RxSwift

final class TextContentUIViewController: UIViewController {
    
    private let textLabel = UILabel()
    private var navTitle: String?
    private var service: Observable<String>!
    private let disposeBag = DisposeBag()
    
    private enum Const {
        static let border: CGFloat = 16
    }
    
    func setup(title: String, service: Observable<String>) {
        self.navTitle = title
        self.service = service
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTitle()
        
        view.addSubview(textLabel)
        UI.fit(textLabel, to: view.safeAreaLayoutGuide, left: Const.border, right: Const.border, top: Const.border)
        textLabel.textAlignment = .left
        textLabel.lineBreakMode = .byWordWrapping
        
        service
            .observe(on: MainScheduler.instance)
            .doLoading(with: Loader(view: view))
            .subscribe { [weak self] (text: String) in
                if let textLabel = self?.textLabel {
                    UI.format(.body, color: .label, label: textLabel, text: text, nrOfLines: 0)
                }
            }.disposed(by: disposeBag)
    }
    
    func setupTitle() {
        if let navTitle = navTitle {
            navigationItem.title = navTitle
        }
    }
}
