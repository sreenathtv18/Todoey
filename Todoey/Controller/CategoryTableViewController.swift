//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Sreenath on 24/01/18.
//  Copyright © 2018 Sreenath. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    let realm = try! Realm()
    var categories: Results<Category>?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategaory()
    }
    //MARK: Button Action
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Category"
            textField = alertTextField
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }))
        present(alert, animated: true) {}
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        return cell
    }
    //MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    //MARK: - Data Manipulation methods
    func loadCategaory() {
        categories =  realm.objects(Category.self)
        tableView.reloadData()
    }
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        }  catch {
            print("Save Catgory Failed \(error)")
        }
        tableView.reloadData()
    }
    //MARK:- Perform segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItem"{
            let destinationVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory =  categories?[indexPath.row]
            }
        }
    }
}
