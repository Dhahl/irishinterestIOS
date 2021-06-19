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
        
        let latest = LatestViewController()
        latest.tabBarItem = BarItem.create(title: "Latest", iconName: "book", selectedIconName: "book.fill")
        
        let authors = UIViewController()
        authors.tabBarItem = BarItem.create(title: "Authors", iconName: "person.3", selectedIconName: "person.3.fill")
        
        let categories = UIViewController()
        categories.tabBarItem = BarItem.create(title: "Categories", iconName: "folder", selectedIconName: "folder.fill")
        
        tabsController.viewControllers = [latest, authors, categories]
        
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

//        let search = SearchViewController()
//        search.tabBarItem = BarItem.create(title: "Search", iconName: "magnifyingglass", selectedIconName: "magnifyingglass")
//        let favourites = UIViewController()
//        favourites.tabBarItem = BarItem.create(title: "Favourites", iconName: "heart", selectedIconName: "heart.fill")
