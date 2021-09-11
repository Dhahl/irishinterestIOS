// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var orientationLock = UIInterfaceOrientationMask.portrait
    let tabsController = TabViewController()
    let store: LocalStore<[String]> = LocalStore<[String]>(userDefaultsKey: "tabController")
    let webService: WebService = WebServiceRemote() //WebServiceLocal()
    var navController: UINavigationController?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        // tabs:
        tabsController.restorationIdentifier = "tabsController"
        let webServiceRef = webService
        
        let search = SearchViewController()
        search.setup(title: "Search", webService: webService) { (book: Book) in
            let detailsViewController = DetailsViewController()
            detailsViewController.bind(model: book, webservice: webServiceRef)
            search.navigationController?.pushViewController(detailsViewController, animated: true)
        }
        search.tabBarItem = BarItem.create(title: "Search", iconName: "magnifyingglass", selectedIconName: "magnifyingglass")
        let searchWrap = UINavigationController(rootViewController: search)
        searchWrap.restorationIdentifier = "search"
        
        
        let authorsAtoZ = AuthorsAtoZViewController()
        authorsAtoZ.setup(webService: webService) { (letter: String) in
            let authorsByLetter = AuthorsByLetterViewController()
            authorsByLetter.setup(authorsObservable: webServiceRef.authors(byLetter: letter), byLetter: letter) { (author: Author) in
                let booksOfAuthorService = WebServicePaging(serviceCall: { page in webServiceRef.books(byAuthorID: author.id, page: page) })
                let booksOfAuthor = ListBooksViewController()
                booksOfAuthor.setup(title: "By: \(author.fullName)",
                                    booksProvider: booksOfAuthorService.items,
                                    onDisplaying: booksOfAuthorService.onDisplayed(index:)) { (book: Book) in
                    let detailsViewController = DetailsViewController()
                    detailsViewController.bind(model: book, webservice: webServiceRef)
                    booksOfAuthor.navigationController?.pushViewController(detailsViewController, animated: true)
                }
                authorsAtoZ.navigationController?.pushViewController(booksOfAuthor, animated: true)
            }
            authorsAtoZ.navigationController?.pushViewController(authorsByLetter, animated: true)
            
        } onSelected: { (author: Author) -> Void in
            let booksOfAuthorService = WebServicePaging(serviceCall: { page in webServiceRef.books(byAuthorID: author.id, page: page) })
            let booksOfAuthor = ListBooksViewController()
            booksOfAuthor.setup(title: "By: \(author.fullName)",
                                booksProvider: booksOfAuthorService.items,
                                onDisplaying: booksOfAuthorService.onDisplayed(index:)) { (book: Book) in
                let detailsViewController = DetailsViewController()
                detailsViewController.bind(model: book, webservice: webServiceRef)
                booksOfAuthor.navigationController?.pushViewController(detailsViewController, animated: true)
            }
            authorsAtoZ.navigationController?.pushViewController(booksOfAuthor, animated: true)
        }
        authorsAtoZ.tabBarItem = BarItem.create(title: "Authors", iconName: "person.3", selectedIconName: "person.3.fill")
        let authorsWrap = UINavigationController(rootViewController: authorsAtoZ)
        authorsWrap.restorationIdentifier = "authors"
        
        
        let categories = CategoriesViewController()
        categories.setup(webService: webService) { (categoryId: Int, categoryTitle: String) in
            let categoryListService = WebServicePaging(serviceCall: { page in webServiceRef.books(byCategoryId: categoryId, page:page) })
            let listBooks = ListBooksViewController()
            listBooks.setup(title: categoryTitle,
                            booksProvider: categoryListService.items,
                            onDisplaying: categoryListService.onDisplayed(index:)) { (book: Book) in
                let detailsViewController = DetailsViewController()
                detailsViewController.bind(model: book, webservice: webServiceRef)
                listBooks.navigationController?.pushViewController(detailsViewController, animated: true)
            }
            categories.navigationController?.pushViewController(listBooks, animated: true)
        }
        categories.tabBarItem = BarItem.create(title: "Categories", iconName: "folder", selectedIconName: "folder.fill")
        let categoriesWrap = UINavigationController(rootViewController: categories)
        categoriesWrap.restorationIdentifier = "categories"
        
        
        let latestBookService = WebServicePaging(serviceCall: webService.booksLatest(page:))
        let latest = ListBooksViewController()
        latest.setup(title: "Latest books", booksProvider: latestBookService.items,
                     onDisplaying: latestBookService.onDisplayed(index:)) { (book: Book) in
            let detailsViewController = DetailsViewController()
            detailsViewController.bind(model: book, webservice: webServiceRef)
            latest.navigationController?.pushViewController(detailsViewController, animated: true)
        }
        latest.tabBarItem = BarItem.create(title: "Latest books", iconName: "book", selectedIconName: "book.fill")
        let latestWrap = UINavigationController(rootViewController: latest)
        latestWrap.restorationIdentifier = "latest"
        
        
        let publishedBookService = WebServicePaging(serviceCall: webService.booksPublished(page:))
        let published = ListBooksViewController()
        published.setup(title: "Published books", booksProvider: publishedBookService.items,
                        onDisplaying: publishedBookService.onDisplayed(index:)) { (book: Book) in
            let detailsViewController = DetailsViewController()
            detailsViewController.bind(model: book, webservice: webServiceRef)
            published.navigationController?.pushViewController(detailsViewController, animated: true)
        }
        published.tabBarItem = BarItem.create(title: "Published books", iconName: "books.vertical", selectedIconName: "books.vertical.fill")
        let publishedWrap = UINavigationController(rootViewController: published)
        publishedWrap.restorationIdentifier = "published"

        let topSearches = ListBooksViewController()
        topSearches.setup(title: "Top searches", booksProvider: .just([]),
                          onDisplaying: { index in print("Top searches: \(index)")}) { (book: Book) in
            let detailsViewController = DetailsViewController()
            detailsViewController.bind(model: book, webservice: webServiceRef)
            topSearches.navigationController?.pushViewController(detailsViewController, animated: true)
        }
        topSearches.tabBarItem = BarItem.create(title: "Top searches", iconName: "1.magnifyingglass", selectedIconName: "1.magnifyingglass")
        let topSearchesWrap = UINavigationController(rootViewController: topSearches)
        topSearches.restorationIdentifier = "topSearches"
        
        let commingSoonService = WebServicePaging(serviceCall: webService.booksComingSoon(page:))
        let comingSoon = ListBooksViewController()
        comingSoon.setup(title: "Coming soon", booksProvider: commingSoonService.items,
                         onDisplaying: commingSoonService.onDisplayed(index:)) { (book: Book) in
            let detailsViewController = DetailsViewController()
            detailsViewController.bind(model: book, webservice: webServiceRef)
            comingSoon.navigationController?.pushViewController(detailsViewController, animated: true)
        }
        comingSoon.tabBarItem = BarItem.create(title: "Coming soon", iconName: "calendar", selectedIconName: "calendar")
        let comingSoonWrap = UINavigationController(rootViewController: comingSoon)
        comingSoonWrap.restorationIdentifier = "comingSoon"
        
        let favourites = FavouritesViewController()
        favourites.tabBarItem = UITabBarItem.init(tabBarSystemItem: .favorites, tag: 0)
        let favouritesWrap = UINavigationController(rootViewController: favourites)
        favouritesWrap.restorationIdentifier = "favourites"
        
        let about = TextContentUIViewController()
        about.setup(title: "About", contents: [
            TextContent(title: "Terms & Conditions", description: webService.termsAndConditions()),
            TextContent(title: "Privacy Policy", description: webService.privacyPolicy()),
            TextContent(title: "Contact us", description: .just("adminstrator@irishinterest.ie"), action: {
                print("emailing us....")
            })
        ])
        about.tabBarItem = BarItem.create(title: "About", iconName: "doc", selectedIconName: "doc.fill")
        let aboutWrap = UINavigationController(rootViewController: about)
        aboutWrap.restorationIdentifier = "about"
        
        let tabs = [searchWrap, authorsWrap, categoriesWrap, latestWrap, publishedWrap, topSearchesWrap, comingSoonWrap, favouritesWrap, aboutWrap]
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
