//  Created by Balazs Perlaki-Horvath on 22/06/2021.

import Foundation
import UIKit

final class SideMenuContainer: UIView {
    
    private let tableView: UITableView = UITableView()
    
    private let model = SideMenuTableModel(items: [
        SideMenuModel(icon: UIImage(systemName: "house.fill")!, title: "Home"),
        SideMenuModel(icon: UIImage(systemName: "music.note")!, title: "Music"),
        SideMenuModel(icon: UIImage(systemName: "film.fill")!, title: "Movies"),
        SideMenuModel(icon: UIImage(systemName: "book.fill")!, title: "Books"),
        SideMenuModel(icon: UIImage(systemName: "person.fill")!, title: "Profile", highlights: false),
        SideMenuModel(icon: UIImage(systemName: "slider.horizontal.3")!, title: "Settings"),
        SideMenuModel(icon: UIImage(systemName: "hand.thumbsup.fill")!, title: "Like us on facebook", highlights: false)
    ])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.937254902, green: 0.6980392157, blue: 0.09411764706, alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
        let headerView = SideMenuHeader()
        addSubview(headerView)
        addSubview(tableView)
        
        model.setUpFor(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    public func setUpSelection(onRowSelected: @escaping (Int) -> Void) {
        model.setUpSelection(onRowSelected: onRowSelected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
