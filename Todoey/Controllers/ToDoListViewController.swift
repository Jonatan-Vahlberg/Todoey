//
//  ViewController.swift
//  Todoey
//
//  Created by ZOG-II on 2019-03-02.
//  Copyright © 2019 Jonatan Vahlberg. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class ToDoListViewController: SwipeTableViewController {
    
    var realm = try! Realm()
    
    var todoItems : Results<Item>?
    
    @IBOutlet var searchBar: UISearchBar!
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name ?? "Items"
        
        guard let colorHex = selectedCategory?.color else{fatalError()}

        updateNavBar(WithHex: colorHex)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(WithHex: "1D9BF6")
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: FlatWhite()]
        
    }
    
    func updateNavBar(WithHex colorHexCode: String){
        guard let navBar = navigationController?.navigationBar else {fatalError("Nav controller does not exsist")}
        
        guard let navBarColor = UIColor(hexString:colorHexCode)else{fatalError()}
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBar.barTintColor!, returnFlat: true)
        
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBar.barTintColor!, returnFlat: true)]
        searchBar.barTintColor = UIColor(hexString:colorHexCode)
        searchBar.layer.borderWidth = 10
        searchBar.layer.borderColor = UIColor(hexString:colorHexCode)?.cgColor
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(CGFloat(indexPath.row) / CGFloat(todoItems!.count))){
                cell.backgroundColor = color
                cell.tintColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
                cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            }
            else{
                
            }
            
            cell.accessoryType = ((item.checked == true) ? .checkmark : .none )
        }
        else{
            cell.textLabel?.text = "No Items Added"
        }
        
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.checked = !item.checked
                    
                }
            }
            catch{
                print("Error Saving In Realm",error)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = todoItems?[indexPath.row]{
            tableView.cellForRow(at: indexPath)?.accessoryType = ((item.checked) ? .checkmark  : .none)
        }else{
            tableView.reloadData()
        }
        
//        todoItems[indexPath.row].checked = !todoItems[indexPath.row].checked
        //saveItems()

    }


    //MARK: - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
       
            if let currentCategory = self.selectedCategory {
                
                do{
                    try self.realm.write{
                        let item = Item()
                        item.title = textFeild.text!
                        item.dateCreated = Date()
                        currentCategory.items.append(item)
                        
                        //self.realm.add(item)
                    }
                }
                catch{
                    print("Error Saving",error)
                }
            }
            
            self.tableView.reloadData()
        }
        alert.addTextField {(alertTextFeild) in
            alertTextFeild.placeholder = "Create new item"
            textFeild = alertTextFeild
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - DATA HANDELING METHODS
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
   
    func deleteItem(for row: Int){

        if let item = todoItems?[row]{
            do{
                try realm.write {
                    realm.delete(item)
                    
                }
            }
            catch{
                print("Error Saving In Realm",error)
            }
            
        }
        //tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        deleteItem(for: indexPath.row)
    }
    
    
}
//MARK: EXTENSIONS
extension ToDoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        if searchBar.text!.count == 0{
            loadItems()
            return
        }
        tableView.reloadData()
        
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

