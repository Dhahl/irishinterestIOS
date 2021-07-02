// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var orientationLock = UIInterfaceOrientationMask.portrait
    let tabsController = TabViewController()
    let store: LocalStore<[String]> = LocalStore<[String]>(userDefaultsKey: "tabController")
    let webService: WebService = WebServiceLocal()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        customizeApplication()
        
        // tabs:
        tabsController.restorationIdentifier = "tabsController"
        let search = SearchViewController()
        search.tabBarItem = BarItem.create(title: "Search", iconName: "magnifyingglass", selectedIconName: "magnifyingglass")
        search.restorationIdentifier = "search"
        
        let authors = AuthorsViewController()
        authors.setup(webService: webService)
        authors.tabBarItem = BarItem.create(title: "Authors", iconName: "person.3", selectedIconName: "person.3.fill")
        authors.restorationIdentifier = "authors"
        
        let categories = CategoriesViewController()
        categories.tabBarItem = BarItem.create(title: "Categories", iconName: "folder", selectedIconName: "folder.fill")
        categories.restorationIdentifier = "categories"
        
        let latest = LatestViewController()
        latest.tabBarItem = BarItem.create(title: "Latest books", iconName: "book", selectedIconName: "book.fill")
        latest.restorationIdentifier = "latest"
        
        let published = PublishedBooksViewController()
        published.tabBarItem = BarItem.create(title: "Published books", iconName: "books.vertical", selectedIconName: "books.vertical.fill")
        published.restorationIdentifier = "published"

        let topSearches = TopSearchesViewController()
        topSearches.tabBarItem = BarItem.create(title: "Top searches", iconName: "1.magnifyingglass", selectedIconName: "1.magnifyingglass")
        topSearches.restorationIdentifier = "topSearches"
        
        let comingSoon = ComingSoonViewController()
        comingSoon.tabBarItem = BarItem.create(title: "Coming soon", iconName: "calendar", selectedIconName: "calendar")
        comingSoon.restorationIdentifier = "comingSoon"
        
        let favourites = FavouritesViewController()
        favourites.tabBarItem = UITabBarItem.init(tabBarSystemItem: .favorites, tag: 0)
        favourites.restorationIdentifier = "favourites"
        
        let tabs = [search, authors, categories, latest, published, topSearches, comingSoon, favourites]
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
        
        let navController = UINavigationController(rootViewController: tabsController)
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
    
    private func customizeApplication() {
//        let navBarAttributes = [
//            NSAttributedString.Key.foregroundColor: Brand.colorPrimary,
//            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!
//        ]
//        UINavigationBar.appearance().titleTextAttributes = navBarAttributes
//        UITabBar.appearance().barTintColor = Brand.colorTabBarBackground
//        UITabBar.appearance().tintColor = Brand.colorTabSelected
//        UITabBar.appearance().unselectedItemTintColor = Brand.colorTabUnselected
    }
}
