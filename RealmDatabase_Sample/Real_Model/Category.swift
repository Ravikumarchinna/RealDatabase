//
//  Category.swift
//  RealmDatabase_Sample
//
//  Created by Ravikumar on 7/10/21.
//

import Foundation
import RealmSwift

class Category: Object {
//.................. Here Declaring the Variables
@objc dynamic var name:String = ""
//...................Here we making the relation ship between the Category and Item
let items = List<Item>()
}
