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
    
    var selectedCategory : Category?{
        didSet {
            loadItems()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count  ?? 1
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
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write({
                    realm.delete(item)
                    //item.done = !item.done
                })
            } catch {
                print("Error while changing done state, \(error)")
            }
            tableView.reloadData()
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert =  UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New Item", style: .default){ [self] action in
            
            if let newTextField = alert.textFields?.first, newTextField.text != "" {
                do {
                    try self.realm.write({
                        let newItem = Item()
                        newItem.title = newTextField.text!
                        selectedCategory?.items.append(newItem)
                    })
                } catch {
                    print("error while saving realm \(error)")
                }
                tableView.reloadData()
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
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
        tableView.reloadData()
        
    }
}


// MARK: - Searchbar delegate methods

extension ItemTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreted",ascending: true)
        tableView.reloadData()
        
        // remove keyboard and make tableview again first responder
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0){
            loadItems()
            
        }
    }
    
}
