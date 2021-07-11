//
//  Item.swift
//  RealmDatabase_Sample
//
//  Created by Ravikumar on 7/10/21.
//

import Foundation
import RealmSwift


class Item: Object {
   
    
    @objc dynamic var name:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated:Date? = nil

    //..............Relation shiop between teh Item and Category
    var parentCategory = LinkingObjects(fromType:Category.self, property: "items")
    
}
