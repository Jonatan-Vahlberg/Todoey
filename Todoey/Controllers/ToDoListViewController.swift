//
//  ViewController.swift
//  Todoey
//
//  Created by ZOG-II on 2019-03-02.
//  Copyright © 2019 Jonatan Vahlberg. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [ItemDataModel]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item = ItemDataModel()
        item.title = "Buy Doggos"
        
        let item2 = ItemDataModel()
        item2.title = "Sell Doggos"
        
        let item3 = ItemDataModel()
        item3.title = "Regret"
        
        itemArray.append(item)
        itemArray.append(item2)
        itemArray.append(item3)
        
        if let items = defaults.array(forKey: "TODOListArray") as! [ItemDataModel]{
            itemArray = items
        }
//        tableView.reloadData()
        
        
    }
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = ((itemArray[indexPath.row].checked == true) ? .checkmark : .none )
        return cell
    }
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        //tableView.reloadData()
        
        
        
        
        tableView.cellForRow(at: indexPath)?.accessoryType = ((itemArray[indexPath.row].checked) ? .none : .checkmark)
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        
        
    }


    //MARK - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let item = ItemDataModel()
            item.title = textFeild.text!
            
            self.itemArray.append(item)
            self.defaults.set(self.itemArray, forKey: "TODOListArray")
            self.tableView.reloadData()
        }
        alert.addTextField {(alertTextFeild) in
            alertTextFeild.placeholder = "Create new item"
            textFeild = alertTextFeild
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}

