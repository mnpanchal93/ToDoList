//
//  ItemTableViewController.swift
//  TodoList
//
//  Created by mansi panchal on 21/06/23.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ItemTableViewController: SwipeTableViewController {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category?{
        didSet {
            loadItems()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar
        else{
            fatalError("Navigation bar not found")
        }
        
        navigationItem.title = selectedCategory?.name
        
        if let navBarColor = UIColor(hexString: selectedCategory!.color){
            navBar.scrollEdgeAppearance?.backgroundColor = navBarColor
            navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
            navBar.scrollEdgeAppearance?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
            
            searchBar.barTintColor = navBarColor
            searchBar.searchTextField.backgroundColor = .white
        }

    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count  ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        var cellConfiguration = UIListContentConfiguration.cell()
        
        if let item = todoItems?[indexPath.row] {
            cellConfiguration.text = item.title
            if let cellColor = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: (CGFloat(indexPath.row)/CGFloat(todoItems!.count))) {
                cell.backgroundColor = cellColor
                cellConfiguration.textProperties.color = UIColor(contrastingBlackOrWhiteColorOn: cellColor, isFlat: true)
            }
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
                    item.done = !item.done
                })
            } catch {
                print("Error while changing done state, \(error)")
            }
            tableView.reloadData()
        }
    }
    
    //MARK: - Add Item method
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert =  UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New Item", style: .default){ [self] action in
            
            if let newTextField = alert.textFields?.first, newTextField.text != "" {
                do {
                    try self.realm.write({
                        let newItem = Item()
                        newItem.title = newTextField.text!
                        newItem.dateCreted = Date()
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
    
    // MARK: - Swipecell methods
    
    override func updateModel(at indexpath: IndexPath) {
        if let itemForDeletion = todoItems?[indexpath.row] {
            do {
                try realm.write({
                    realm.delete(itemForDeletion)
                })
            } catch {
                print("erro while deleting item \(error)")
            }
        }
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
