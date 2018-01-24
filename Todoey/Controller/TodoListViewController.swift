//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Sreenath on 23/01/18.
//  Copyright © 2018 Sreenath. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    var userDefault = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
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
        saveItems()
    }

    //MARK: Add New Item

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let item = Item(context: self.context)
            item.title = textField.text!
            item.done = false
            self.itemArray.append(item)
            self.saveItems()
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
    func saveItems() {
        do {
            try context.save()
        }
        catch {
            print("Error encoding the array \(error)")
        }
        tableView.reloadData()
    }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print("Fetch request failed \(error)")
        }
    }
}
//MARK:- Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Search request failed \(error)")

        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        loadItems()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}

