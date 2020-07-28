//
//  ToDoModel.swift
//  Todo List
//
//  Created by Rohit sahu on 27/07/20.
//  Copyright © 2020 sha_since1999. All rights reserved.
//

import Foundation

class ToDo : Encodable ,Decodable{
    var title : String = ""
    var isdone : Bool = false
}
