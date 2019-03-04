//
//  Item.swift
//  Todoey
//
//  Created by ZOG-II on 2019-03-04.
//  Copyright © 2019 Jonatan Vahlberg. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    
    @objc dynamic var title: String = ""
    @objc dynamic var checked: Bool = false
    @objc dynamic var dateCreated : Date?
    
    var parentCatergory = LinkingObjects(fromType: Category.self, property: "items")
}
