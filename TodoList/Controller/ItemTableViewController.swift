//
//  ItemTableViewController.swift
//  TodoList
//
//  Created by mansi panchal on 21/06/23.
//

import UIKit

class ItemTableViewController: UITableViewController {
    
    var itemArray = ["Cleaning","Mopping"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        var cellConfiguration = UIListContentConfiguration.cell()
        cellConfiguration.text = itemArray[indexPath.row]
        cell.contentConfiguration = cellConfiguration
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
            }
            else{
                cell.accessoryType = .checkmark
            }
        }
    }

}
