//
//  DataRealm.swift
//  Task1Presents
//
//  Created by Andrew Cheberyako on 08.07.2021.
//

import Foundation
import RealmSwift

class Prize: Object {
    @objc dynamic var title = ""
    @objc dynamic var price = 0
    @objc dynamic var selected = false
    @objc dynamic var prizeID = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return "prizeID"
    }
}
