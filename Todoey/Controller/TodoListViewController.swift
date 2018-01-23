//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Sreenath on 23/01/18.
//  Copyright © 2018 Sreenath. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    var userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let newItem = Item()
        newItem.title = "Find Milk"
        itemArray.append(newItem)
        let newItem2 = Item()
        newItem2.title = "Find Egg"
        itemArray.append(newItem2)
        let newItem3 = Item()
        newItem3.title = "Find Books"
        itemArray.append(newItem3)

        if let arrayList = userDefault.array(forKey:"TodoListArray") as? [Item] {
            itemArray = arrayList
        }
    }
    //MARK:- Table Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    //MARK:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        itemArray[indexPath.row].done =  !itemArray[indexPath.row].done
        tableView.reloadData()
    }
    //MARK: Add New Item

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let item = Item()
            item.title = textField.text!
            self.itemArray.append(item)
            self.userDefault.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        alert.addTextField { (alerTextField) in
            alerTextField.placeholder = "Create New Item"
            textField = alerTextField
        }
        alert.addAction(action)
        present(alert, animated: true) {
            //
        }
    }
}

