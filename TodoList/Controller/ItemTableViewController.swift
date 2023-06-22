//
//  ItemTableViewController.swift
//  TodoList
//
//  Created by mansi panchal on 21/06/23.
//

import UIKit
import RealmSwift

class ItemTableViewController: UITableViewController {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadItems()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        var cellConfiguration = UIListContentConfiguration.cell()
        
        if let item = todoItems?[indexPath.row] {
            cellConfiguration.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cellConfiguration.text = "No Items added"
            cell.isUserInteractionEnabled = false
            
        }
        
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
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert =  UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New Item", style: .default){ action in
            
            if let newTextField = alert.textFields?.first, newTextField.text != "" {
                let newItem = Item()
                newItem.title = newTextField.text!
                newItem.done = false
                
                self.saveItems(newItem)
            }
          
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Item"
        }
        
        alert.addAction(action)
        
        present(alert, animated: false, completion: nil)
    }
    
    // MARK: - Data Model Methods
    
    
    func loadItems() {
        
        todoItems = realm.objects(Item.self)
        tableView.reloadData()
        
    }
    
    func saveItems(_ newItem: Item) {
        do {
            try realm.write({
                realm.add(newItem)
                tableView.reloadData()
            })
        }catch {
            print("error while saving realm \(error)")
        }
    }
    
    
}
