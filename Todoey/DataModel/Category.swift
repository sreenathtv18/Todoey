//
//  Category.swift
//  Todoey
//
//  Created by Sreenath on 24/01/18.
//  Copyright © 2018 Sreenath. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var cellBackgroundColor: String = ""
    let items = List<Item>()
}
