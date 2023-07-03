//
//  CategoryTableViewController.swift
//  TodoList
//
//  Created by mansi panchal on 22/06/23.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {

    var categories : Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
                
        var cellConfiguration = UIListContentConfiguration.cell()
        
        if let category = categories?[indexPath.row] {
            cellConfiguration.text = category.name
            cell.backgroundColor = UIColor(hexString: category.color)

        } else {
            cellConfiguration.text = "No Categories Added"
            cell.isUserInteractionEnabled = false
            
        }
        
        cell.contentConfiguration = cellConfiguration
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    // MARK: - Add Category Method

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert =  UIAlertController(title: "Add New Todo Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New Category", style: .default){ [self] action in
            
            if let newTextField = alert.textFields?.first, newTextField.text != "" {
                do {
                    try self.realm.write({
                        let newCategory = Category()
                        newCategory.name = newTextField.text!
                        newCategory.color = UIColor.randomFlat().hexValue()
                        self.realm.add(newCategory)
                    })
                } catch {
                    print("error while saving realm \(error)")
                }
                tableView.reloadData()
            }
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Category"
        }
        
        alert.addAction(action)
        
        present(alert, animated: false, completion: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
        let destinationVC = segue.destination as! ItemTableViewController
        if let indexPath =  tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Data model
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    // MARK: - Swipetable delegate
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryFordeletion =  categories?[indexPath.row]{
            do {
                try realm.write({
                    realm.delete(categoryFordeletion)
                })
            } catch {
                print("erro while deleting category \(error)")
            }
        }
    }

}
