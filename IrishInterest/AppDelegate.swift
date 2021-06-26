// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        customizeApplication()
        
        // tabs:
        let tabsController = TabViewController()
        
        let search = SearchViewController()
        search.tabBarItem = BarItem.create(title: "Search", iconName: "magnifyingglass", selectedIconName: "magnifyingglass")
        
        let authors = AuthorsViewController()
        authors.tabBarItem = BarItem.create(title: "Authors", iconName: "person.3", selectedIconName: "person.3.fill")
        
        let categories = CategoriesViewController()
        categories.tabBarItem = BarItem.create(title: "Categories", iconName: "folder", selectedIconName: "folder.fill")
        
        let latest = LatestViewController()
        latest.tabBarItem = BarItem.create(title: "Latest books", iconName: "book", selectedIconName: "book.fill")
        
        let published = UIViewController()
        published.tabBarItem = BarItem.create(title: "Published books", iconName: "books.vertical", selectedIconName: "books.vertical.fill")

        let topSearches = UIViewController()
        topSearches.tabBarItem = BarItem.create(title: "Top searches", iconName: "1.magnifyingglass", selectedIconName: "1.magnifyingglass")
        
        let commingSoon = UIViewController()
        commingSoon.tabBarItem = BarItem.create(title: "Coming soon", iconName: "calendar", selectedIconName: "calendar")
        
        let favourites = UIViewController()
        favourites.tabBarItem = UITabBarItem.init(tabBarSystemItem: .favorites, tag: 0)
        
        tabsController.viewControllers = [search, authors, categories, latest, published, topSearches, commingSoon, favourites]
        tabsController.customizableViewControllers = []
        
        let navController = UINavigationController(rootViewController: tabsController)
        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    private func customizeApplication() {
        let navBarAttributes = [
            NSAttributedString.Key.foregroundColor: Brand.colorPrimary,
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!
        ]
        UINavigationBar.appearance().titleTextAttributes = navBarAttributes
    }


}


//        let favourites = UIViewController()
//        favourites.tabBarItem = BarItem.create(title: "Favourites", iconName: "heart", selectedIconName: "heart.fill")
