//
//  Items.swift
//  Todo List
//
//  Created by Rohit sahu on 28/07/20.
//  Copyright © 2020 sha_since1999. All rights reserved.
//

import Foundation
import RealmSwift
class Item: Object {
    @objc dynamic var title : String? = nil
    @objc dynamic var done  : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType : Category.self,property :"Items")
    }
