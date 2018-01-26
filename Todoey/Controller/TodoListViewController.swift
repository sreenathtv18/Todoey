//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Sreenath on 23/01/18.
//  Copyright © 2018 Sreenath. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navColor = selectedCategory?.cellBackgroundColor else {fatalError()}
        updateNavigation(withHexCode: navColor )
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        updateNavigation(withHexCode: "1D9BF6")
    }
    //MARK: Set Navigation
    func updateNavigation(withHexCode hexCode: String) {
        title = selectedCategory?.name
        guard let nav = navigationController?.navigationBar else {fatalError("Navigation controller is not loaded")}
        guard let navColor = UIColor(hexString:hexCode ) else {fatalError()}
        nav.barTintColor = navColor
        nav.tintColor = ContrastColorOf(navColor, returnFlat: true)
        nav.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navColor, returnFlat: true)]
        searchBar.barTintColor = navColor

    }
    //MARK:- Table Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            cell.backgroundColor = UIColor(hexString: selectedCategory!.cellBackgroundColor)!.darken(byPercentage: percentageOfColor(index: indexPath.row))
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)

        } else {
            cell.textLabel?.text = "No Item Added"
        }
        return cell
    }
    //MARK:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let item =  toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
    }
    //MARK: Percentage
    func percentageOfColor(index: Int) -> CGFloat {
        if let totalCount = toDoItems?.count {
            return
                CGFloat(index)/CGFloat(totalCount)
        }
        return CGFloat(0.0)
    }

    //MARK: Add New Item

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        self.tableView.reloadData()
                    }
                }
                catch {
                    print("Error encoding the array \(error)")
                }
            }
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
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    //MARK:- Swipe Delete Handler
    override func deleteHandler(indexPath: IndexPath) {
        do {

            try self.realm.write {
                self.realm.delete(self.toDoItems![indexPath.row])
            }
        } catch {
            print("Item Can't be deleted \(error)")
        }
    }
}
//MARK:- Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        toDoItems = toDoItems?.filter(predicate).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

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

