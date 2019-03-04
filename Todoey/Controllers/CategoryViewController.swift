//
//  CategoryViewController.swift
//  Todoey
//
//  Created by ZOG-II on 2019-03-04.
//  Copyright © 2019 Jonatan Vahlberg. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (alert) in
            let category = Category(context: self.context)
            category.name = textFeild.text!
            
            self.categoryArray.append(category)
            self.saveCategories()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.placeholder = "Type New Category"
            textFeild = alertTextFeild
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "categoryCell")
        
        cell?.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell!
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Core Data Handeling
    
    func saveCategories(){
        do{
            try context.save()
        }catch{
            print("Error Saving Data",error)
        }
        
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("Error Loading Categories",error)
        }
    }
    
    func deleteCategory(for row: Int){
        context.delete(categoryArray[row])
        categoryArray.remove(at: row)
        saveCategories()
    }
    
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categoryArray[indexPath.row]
        }
    }
}
