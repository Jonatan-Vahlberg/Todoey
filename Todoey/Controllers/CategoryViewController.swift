//
//  CategoryViewController.swift
//  Todoey
//
//  Created by ZOG-II on 2019-03-04.
//  Copyright © 2019 Jonatan Vahlberg. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
    
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        
        cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].color ?? "ffffff")
        cell.tintColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Data Handeling
    
    func save(A category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error Saving Data",error)
        }
        
    }
    
    func loadCategories(){
        categoryArray = realm.objects(Category.self)
    }
    
    func deleteCategory(for row: Int){
        if let category = categoryArray?[row]{
            do{
                try realm.write {
                    realm.delete(category)
                    
                }
            }
            catch{
                print("Error Saving In Realm",error)
            }
            
        }
        
        //tableView.reloadData()
    }
    
    
    override func updateModel(at indexPath: IndexPath) {
        deleteCategory(for: indexPath.row)
    }
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (alert) in
            let category = Category()
            category.name = textFeild.text!
            category.color = UIColor.randomFlat.hexValue()
            
            
            self.save(A: category)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.placeholder = "Type New Category"
            textFeild = alertTextFeild
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
}



