//
//  Item.swift
//  TodoList
//
//  Created by mansi panchal on 21/06/23.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
    @Persisted var parentCategory =  LinkingObjects(fromType: Category.self, property: "items")
    @Persisted var dateCreted: Date?
}
