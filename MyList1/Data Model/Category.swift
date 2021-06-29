//
//  Category.swift
//  MyList1
//
//  Created by Helcio Junior on 13/01/21.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
