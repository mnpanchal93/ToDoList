//
//  Category.swift
//  TodoList
//
//  Created by mansi panchal on 22/06/23.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @Persisted var name : String = ""
    @Persisted var color : String = ""
    @Persisted var items = List<Item>()
    
}
