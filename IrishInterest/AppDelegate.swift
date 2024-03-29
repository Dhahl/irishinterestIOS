// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import UIKit
import MessageUI
import RxSwift

final class MailDelegate: NSObject, MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private enum Const {
        static let emailTo = "adminstrator@irishinterest.ie"
    }

    var window: UIWindow?
    static var orientationLock = UIInterfaceOrientationMask.portrait
    let tabsController = TabViewController()
    let store: LocalStore<[String]> = LocalStore<[String]>(userDefaultsKey: "tabController")
    let webService: WebService = WebServiceRemote() //WebServiceLocal()
    let favouritesStore = LocalStore<[Book]>(userDefaultsKey: "favouriteBooksStore")
    var favouritesService: FavouritesObservable!
    var navController: UINavigationController?
    let mailDelegate: MFMailComposeViewControllerDelegate = MailDelegate()
    let disposeBag = DisposeBag()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let favouritesServiceRef = FavouritesObservable(stored: favouritesStore.read() ?? [])
        favouritesService = favouritesServiceRef
        favouritesServiceRef.booksObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (favBooks: [Book]) in
                try? self?.favouritesStore.write(favBooks)
            }.disposed(by: disposeBag)
        
        let webServiceRef = webService
        
        // MARK: authorDetails
        let showAuthorDetails: (Int, UINavigationController?) -> Void = { (authorId: Int, navController: UINavigationController?) in
            print("show author details for: \(authorId)")
        }
        
        // MARK: bookDetails
        let showBookDetails: (Book, [Author], UINavigationController?) -> Void = {
            (book: Book, authors: [Author], navController: UINavigationController?) in
            let detailsViewController = DetailsViewController()
            detailsViewController.bind(model: book,
                                       authors: authors,
                                       webservice: webServiceRef,
                                       favouriteService: favouritesServiceRef,
                                       onAuthorSelected: { (auth: Int) in showAuthorDetails(auth, navController) })
            navController?.pushViewController(detailsViewController, animated: true)
        }
        
        
        // MARK: search
        tabsController.restorationIdentifier = "tabsController"
        
        let search = SearchViewController()
        search.setup(title: "Search", webService: webService) { (book: Book, authors: [Author]) in
            showBookDetails(book, authors, search.navigationController)
        }
        search.tabBarItem = BarItem.create(title: "Search", iconName: "magnifyingglass", selectedIconName: "magnifyingglass")
        let searchWrap = UINavigationController(rootViewController: search)
        searchWrap.restorationIdentifier = "search"
        
        // MARK: authors A-Z
        let authorsAtoZ = AuthorsAtoZViewController()
        authorsAtoZ.setup(webService: webService) { (letter: String) in
            let authorsByLetter = AuthorsByLetterViewController()
            authorsByLetter.setup(authorsObservable: webServiceRef.authors(byLetter: letter), byLetter: letter) { (author: Author) in
                let booksOfAuthorService = WebServicePaging(serviceCall: { page in webServiceRef.books(byAuthorID: author.id, page: page) })
                let booksOfAuthor = ListBooksViewController()
                booksOfAuthor.setup(title: "By: \(author.fullName)",
                                    booksProvider: booksOfAuthorService.items,
                                    authorsProvider: webServiceRef.authors(ofBooks:),
                                    onDisplaying: booksOfAuthorService.onDisplayed(index:),
                                    onSelected: { (book: Book, authors: [Author]) in
                                        showBookDetails(book, authors, booksOfAuthor.navigationController)
                                    })
                authorsAtoZ.navigationController?.pushViewController(booksOfAuthor, animated: true)
            }
            authorsAtoZ.navigationController?.pushViewController(authorsByLetter, animated: true)
            
        } onSelected: { (author: Author) -> Void in
            let booksOfAuthorService = WebServicePaging(serviceCall: { page in webServiceRef.books(byAuthorID: author.id, page: page) })
            let booksOfAuthor = ListBooksViewController()
            booksOfAuthor.setup(title: "By: \(author.fullName)",
                                booksProvider: booksOfAuthorService.items,
                                authorsProvider: webServiceRef.authors(ofBooks:),
                                onDisplaying: booksOfAuthorService.onDisplayed(index:),
                                onSelected: { (book: Book, authors: [Author]) in
                                    showBookDetails(book, authors, booksOfAuthor.navigationController)
                                })
            authorsAtoZ.navigationController?.pushViewController(booksOfAuthor, animated: true)
        }
        authorsAtoZ.tabBarItem = BarItem.create(title: "Authors", iconName: "person.3", selectedIconName: "person.3.fill")
        let authorsWrap = UINavigationController(rootViewController: authorsAtoZ)
        authorsWrap.restorationIdentifier = "authors"
        
        // MARK: categories
        let categories = CategoriesViewController()
        categories.setup(webService: webService) { (categoryId: Int, categoryTitle: String) in
            let categoryListService = WebServicePaging(serviceCall: { page in webServiceRef.books(byCategoryId: categoryId, page:page) })
            let listBooks = ListBooksViewController()
            listBooks.setup(title: categoryTitle,
                            booksProvider: categoryListService.items,
                            authorsProvider: webServiceRef.authors(ofBooks:),
                            onDisplaying: categoryListService.onDisplayed(index:),
                            onSelected: { (book: Book, authors: [Author]) in
                                showBookDetails(book, authors, listBooks.navigationController)
                            })
            categories.navigationController?.pushViewController(listBooks, animated: true)
        }
        categories.tabBarItem = BarItem.create(title: "Categories", iconName: "folder", selectedIconName: "folder.fill")
        let categoriesWrap = UINavigationController(rootViewController: categories)
        categoriesWrap.restorationIdentifier = "categories"
        
        // MARK: latest books
        let latestBookService = WebServicePaging(serviceCall: webService.booksLatest(page:))
        let latest = ListBooksViewController()
        latest.setup(title: "Latest books",
                     booksProvider: latestBookService.items,
                     authorsProvider: webServiceRef.authors(ofBooks:),
                     onDisplaying: latestBookService.onDisplayed(index:),
                     onSelected: { (book: Book, authors: [Author]) in
                         showBookDetails(book, authors, latest.navigationController)
                     })
        latest.tabBarItem = BarItem.create(title: "Latest books", iconName: "book", selectedIconName: "book.fill")
        let latestWrap = UINavigationController(rootViewController: latest)
        latestWrap.restorationIdentifier = "latest"
        
        // MARK: published books
        let publishedBookService = WebServicePaging(serviceCall: webService.booksPublished(page:))
        let published = ListBooksViewController()
        published.setup(title: "Published books",
                        booksProvider: publishedBookService.items,
                        authorsProvider: webServiceRef.authors(ofBooks:),
                        onDisplaying: publishedBookService.onDisplayed(index:),
                        onSelected: { (book: Book, authors: [Author]) in
                            showBookDetails(book, authors, published.navigationController)
                        })
        published.tabBarItem = BarItem.create(title: "Published books", iconName: "books.vertical", selectedIconName: "books.vertical.fill")
        let publishedWrap = UINavigationController(rootViewController: published)
        publishedWrap.restorationIdentifier = "published"

//        // MARK: top searches
//        let topSearches = ListBooksViewController()
//        topSearches.setup(title: "Top searches", booksProvider: .just([]),
//                          onDisplaying: { index in print("Top searches: \(index)")}) { (book: Book) in
//            let detailsViewController = DetailsViewController()
//            detailsViewController.bind(model: book, webservice: webServiceRef, favouriteService: favouritesServiceRef)
//            topSearches.navigationController?.pushViewController(detailsViewController, animated: true)
//        }
//        topSearches.tabBarItem = BarItem.create(title: "Top searches", iconName: "1.magnifyingglass", selectedIconName: "1.magnifyingglass")
//        let topSearchesWrap = UINavigationController(rootViewController: topSearches)
//        topSearches.restorationIdentifier = "topSearches"
        
        // MARK: comming soon
        let commingSoonService = WebServicePaging(serviceCall: webService.booksComingSoon(page:))
        let comingSoon = ListBooksViewController()
        comingSoon.setup(title: "Coming soon",
                         booksProvider: commingSoonService.items,
                         authorsProvider: webServiceRef.authors(ofBooks:),
                         onDisplaying: commingSoonService.onDisplayed(index:),
                         onSelected: { (book: Book, authors: [Author]) in
                             showBookDetails(book, authors, comingSoon.navigationController)
                         })
        comingSoon.tabBarItem = BarItem.create(title: "Coming soon", iconName: "calendar", selectedIconName: "calendar")
        let comingSoonWrap = UINavigationController(rootViewController: comingSoon)
        comingSoonWrap.restorationIdentifier = "comingSoon"
        
        // MARK: favourites
        let favourites = ListBooksViewController()
        favourites.setup(title: "Favourites",
                         booksProvider: favouritesService.booksObservable,
                         authorsProvider: webServiceRef.authors(ofBooks:),
                         onDisplaying: { _ in },
                         onSelected: { (book: Book, authors: [Author]) in
                             showBookDetails(book, authors, favourites.navigationController)
                         })
        favourites.tabBarItem = UITabBarItem.init(tabBarSystemItem: .favorites, tag: 0)
        let favouritesWrap = UINavigationController(rootViewController: favourites)
        favouritesWrap.restorationIdentifier = "favourites"
        
        // MARK: about
        let about = TextContentUIViewController()
        about.setup(title: "About", contents: [
            TextContent(title: "Terms & Conditions", description: webService.termsAndConditions()),
            TextContent(title: "Privacy Policy", description: webService.privacyPolicy()),
            TextContent(title: "Contact us", description: .just(Const.emailTo), tapRecognizer: UITapGestureRecognizer(target: self, action: #selector(self.onContactUs)))
        ])
        about.tabBarItem = BarItem.create(title: "About", iconName: "doc", selectedIconName: "doc.fill")
        let aboutWrap = UINavigationController(rootViewController: about)
        aboutWrap.restorationIdentifier = "about"
        
        // MARK: tabs
        let tabs = [latestWrap, searchWrap, authorsWrap, categoriesWrap, publishedWrap, comingSoonWrap, favouritesWrap, aboutWrap]
        if let order = store.read() {
            tabsController.viewControllers = tabs.sorted(by: { (a: UIViewController, b: UIViewController) in
                guard let aID: String = a.restorationIdentifier,
                      let bID: String = b.restorationIdentifier,
                      let indexA: Int = order.firstIndex(of: aID),
                      let indexB: Int = order.firstIndex(of: bID) else {
                    return false
                }
                return indexA <= indexB
            })
        } else {
            tabsController.viewControllers = tabs
        }
        
        self.navController = UINavigationController(rootViewController: tabsController)
        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
    
    @objc func onContactUs() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = mailDelegate
            mailComposerVC.setToRecipients([Const.emailTo])
            mailComposerVC.setSubject("")
            mailComposerVC.setMessageBody("", isHTML: false)
            navController?.present(mailComposerVC, animated: true, completion: nil)
        } else {
            UIApplication.shared.open(URL(string: "mailto:\(Const.emailTo)")!)
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if let controllers = tabsController.viewControllers {
            let restoreIds = controllers.compactMap({ (controller: UIViewController) -> String? in
                controller.restorationIdentifier
            })
            try? store.write(restoreIds)
        }
    }
}
