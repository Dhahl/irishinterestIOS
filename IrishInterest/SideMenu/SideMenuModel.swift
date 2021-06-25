//  Created by Balazs Perlaki-Horvath on 22/06/2021.

import Foundation
import UIKit

final class SideMenuTableModel: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private enum Const {
        static let cellID: String = "SideMenuCellID"
    }
    
    private let items: [SideMenuModel]
    private var onRowSelected: ((Int) -> Void)?
    
    public init(items: [SideMenuModel]) {
        self.items = items
    }
    
    func setUpFor(_ tableView: UITableView) {
        tableView.register(SideMenuTableViewCell.self, forCellReuseIdentifier: Const.cellID)
        tableView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.6980392157, blue: 0.09411764706, alpha: 1)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUpSelection(onRowSelected: @escaping (Int) -> Void) {
        self.onRowSelected = onRowSelected
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellID, for: indexPath) as? SideMenuTableViewCell else { fatalError("class not found") }

        cell.setup(with: items[indexPath.row])

        // Selected color
        let selectionBackground = UIView()
        selectionBackground.backgroundColor = #colorLiteral(red: 0.7215686275, green: 0.5137254902, blue: 0, alpha: 1)
        cell.selectedBackgroundView = selectionBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onRowSelected?(indexPath.row)
        
        //turn off highlight post selection for pop up like navs
        let model = items[indexPath.row]
        if !model.highlights {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
