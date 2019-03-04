//
//  ViewController.swift
//  Todoey
//
//  Created by ZOG-II on 2019-03-02.
//  Copyright © 2019 Jonatan Vahlberg. All rights reserved.
//

import UIKit
import CoreData


class ToDoListViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = ((itemArray[indexPath.row].checked == true) ? .checkmark : .none )
        return cell
    }
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        tableView.cellForRow(at: indexPath)?.accessoryType = ((itemArray[indexPath.row].checked) ? .none : .checkmark)
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        saveItems()

    }


    //MARK: - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            
            let item = Item(context: self.context)
            item.title = textFeild.text!
            item.checked = false
            item.parentCategory = self.selectedCategory
            
            self.itemArray.append(item)
            self.saveItems()
            self.tableView.reloadData()
        }
        alert.addTextField {(alertTextFeild) in
            alertTextFeild.placeholder = "Create new item"
            textFeild = alertTextFeild
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - CORE DATA METHODS
    func saveItems(){
        
        
        do{
            try context.save()
        }
        catch{
            print("Error Saving",error)
        }
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let adtitionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,adtitionalPredicate])
        }
        else{
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        }
        catch{
            print("Error Fetching data")
        }
        
        tableView.reloadData()
    }
    
    //deletes one item att index: Row
    func deleteItem(row: Int){
        
        context.delete(itemArray[row])
        itemArray.remove(at: row)
        saveItems()
    }
    
    
}
//MARK: EXTENSIONS
extension ToDoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        if searchBar.text! == ""{
            loadItems()
            return
        }
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request,predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

