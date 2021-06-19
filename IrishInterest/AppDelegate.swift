// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        // tabs:
        let tabsController = TabViewController()
        
        let home = HomeViewController()
        home.tabBarItem = TabBarItem.create(title: "Home", iconName: "book", selectedIconName: "book.fill")
        
        let authors = UIViewController()
        authors.tabBarItem = TabBarItem.create(title: "Authors", iconName: "person.3", selectedIconName: "person.3.fill")
        
        let search = SearchViewController()
        search.tabBarItem = TabBarItem.create(systemIcon: .search, tag: 1)
        
        tabsController.viewControllers = [home, authors, search]
        
        let navController = UINavigationController(rootViewController: tabsController)
        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }


}

