//
//  DataRealm.swift
//  Task1Presents
//
//  Created by Andrew Cheberyako on 08.07.2021.
//

import Foundation
import RealmSwift

class PrizeList: Object {
    @objc dynamic var namePrize = ""
    @objc dynamic var prise = 0
    @objc dynamic var selected = false
    @objc dynamic var personID = UUID().uuidString
    
    override static func primaryKey() -> String? {
       return "personID"
     }
}
