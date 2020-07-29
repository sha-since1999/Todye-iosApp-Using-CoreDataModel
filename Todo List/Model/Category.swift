//
//  Model.swift
//  Todo List
//
//  Created by Rohit sahu on 28/07/20.
//  Copyright © 2020 sha_since1999. All rights reserved.
//

import Foundation
import RealmSwift
class Category : Object {
    @objc dynamic var name : String? = nil
    @objc dynamic var color : String = "#f1c40f"
    var items = List<Item>()
    
}
