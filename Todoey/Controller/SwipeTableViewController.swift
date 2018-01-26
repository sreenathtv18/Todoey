//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Sreenath on 25/01/18.
//  Copyright © 2018 Sreenath. All rights reserved.
//

import UIKit
import SwipeCellKit


class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Item Deleted")
            self.deleteHandler(indexPath: indexPath)
            
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    //MARK: Delete Cell Action
    func deleteHandler(indexPath: IndexPath) {

    }
    //MARK: - Set Row Height
    func setTableView() {
        tableView.rowHeight =  80.0
        tableView.separatorStyle = .none
    }

}
