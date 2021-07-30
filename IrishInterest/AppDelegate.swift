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
        
        let search = SearchViewController()
        search.tabBarItem = BarItem.create(title: "Search", iconName: "magnifyingglass", selectedIconName: "magnifyingglass")
        let searchWrap = UINavigationController(rootViewController: search)
        searchWrap.restorationIdentifier = "search"
        
        let authors = AuthorsViewController()
        authors.setup(webService: webService)
        authors.tabBarItem = BarItem.create(title: "Authors", iconName: "person.3", selectedIconName: "person.3.fill")
        let authorsWrap = UINavigationController(rootViewController: authors)
        authorsWrap.restorationIdentifier = "authors"
        
        let webServiceRef = webService
        
        let categories = CategoriesViewController()
        categories.setup(webService: webService) { (categoryId: Int, categoryTitle: String) in
            let listBooks = ListBooksViewController()
            listBooks.setup(title: categoryTitle,
                            booksProvider: webServiceRef.booksBy(categoryId: categoryId)) { (book: Book) in
                let detailsViewController = DetailsViewController()
                detailsViewController.bind(model: book, webservice: webServiceRef)
                listBooks.navigationController?.pushViewController(detailsViewController, animated: true)
            }
            categories.navigationController?.pushViewController(listBooks, animated: true)
        }
        categories.tabBarItem = BarItem.create(title: "Categories", iconName: "folder", selectedIconName: "folder.fill")
        let categoriesWrap = UINavigationController(rootViewController: categories)
        categoriesWrap.restorationIdentifier = "categories"
        
        let latest = ListBooksViewController()
        latest.setup(title: "Latest books", booksProvider: webService.latestBooks(page: 0)) { (book: Book) in
            let detailsViewController = DetailsViewController()
            detailsViewController.bind(model: book, webservice: webServiceRef)
            latest.navigationController?.pushViewController(detailsViewController, animated: true)
        }
        latest.tabBarItem = BarItem.create(title: "Latest books", iconName: "book", selectedIconName: "book.fill")
        let latestWrap = UINavigationController(rootViewController: latest)
        latestWrap.restorationIdentifier = "latest"
        
        let published = ListBooksViewController()
        published.setup(title: "Published books", booksProvider: webService.latestBooks(page: 30)) { (book: Book) in
            let detailsViewController = DetailsViewController()
            detailsViewController.bind(model: book, webservice: webServiceRef)
            published.navigationController?.pushViewController(detailsViewController, animated: true)
        }
        published.tabBarItem = BarItem.create(title: "Published books", iconName: "books.vertical", selectedIconName: "books.vertical.fill")
        let publishedWrap = UINavigationController(rootViewController: published)
        publishedWrap.restorationIdentifier = "published"

        let topSearches = TopSearchesViewController()
        topSearches.tabBarItem = BarItem.create(title: "Top searches", iconName: "1.magnifyingglass", selectedIconName: "1.magnifyingglass")
        let topSearchesWrap = UINavigationController(rootViewController: topSearches)
        topSearches.restorationIdentifier = "topSearches"
        
        let comingSoon = ComingSoonViewController()
        comingSoon.tabBarItem = BarItem.create(title: "Coming soon", iconName: "calendar", selectedIconName: "calendar")
        let comingSoonWrap = UINavigationController(rootViewController: comingSoon)
        comingSoonWrap.restorationIdentifier = "comingSoon"
        
        let favourites = FavouritesViewController()
        favourites.tabBarItem = UITabBarItem.init(tabBarSystemItem: .favorites, tag: 0)
        let favouritesWrap = UINavigationController(rootViewController: favourites)
        favouritesWrap.restorationIdentifier = "favourites"
        
        let tabs = [searchWrap, authorsWrap, categoriesWrap, latestWrap, publishedWrap, topSearchesWrap, comingSoonWrap, favouritesWrap]
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
