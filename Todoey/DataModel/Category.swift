//
//  Category.swift
//  Todoey
//
//  Created by ZOG-II on 2019-03-04.
//  Copyright © 2019 Jonatan Vahlberg. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
