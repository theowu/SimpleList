//
//  Checklist.swift
//  SimpleList
//
//  Created by Theo WU on 30/07/2016.
//  Copyright © 2016 Theo WU. All rights reserved.
//

import Foundation

class SimpleList: NSObject, NSCoding {
    var name: String
    var iconName: String
    var items = [SimpleListItem]()
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("Name") as! String
        iconName = aDecoder.decodeObjectForKey("IconName") as! String
        items = aDecoder.decodeObjectForKey("Items") as! [SimpleListItem]
        super.init()
    }
    
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(iconName, forKey: "IconName")
        aCoder.encodeObject(items, forKey: "Items")
    }
    
    func countUncheckedItems() -> Int? {
        if items.isEmpty {
            return nil
        }
        var count = 0
        for item in items where !item.checkState {
            count += 1
        }
        return count
    }
    
    func sortSimpleListItemsByDueDate() {
        items.sortInPlace({item1, item2 in return item1.dueDate.compare(item2.dueDate) == .OrderedAscending})
    }
    
}
