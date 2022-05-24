//
//  AllTasks.swift
//  MyTasks
//
//  Created by Manu Safarov on 18.05.2021.
//

import UIKit

class Tasks: NSObject, Codable {
    var name = ""
    var items = [TasksListItem]()
    var iconName = "Other"
    
    init(name: String, iconName: String = "Other") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
}
