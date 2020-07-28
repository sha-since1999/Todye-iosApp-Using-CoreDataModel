//
//  Model.swift
//  Todo List
//
//  Created by Rohit sahu on 28/07/20.
//  Copyright © 2020 sha_since1999. All rights reserved.
//

import Foundation
import RealmSwift
class Data : Object {
    @objc dynamic var title : String? = nil
    var isdone : Bool? = false
}
