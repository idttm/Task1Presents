//
//  NewPrizeModel.swift
//  Task1Presents
//
//  Created by Andrew Cheberyako on 12.07.2021.
//

import Foundation
import RealmSwift

class NewPrizeModel {
    
    let realm = try! Realm()
    var items: Results<Prize>!
    let maxSum = 100
    
    func addNewPresent(name: String, priceInt: Int, completion: @escaping (Error?) -> Void){
        if priceInt >= maxSum || priceInt <= 0 {
            completion(PriceCalculationsError.highPrice)
        } else {
            let priceString = Int(priceInt)
            let present = Prize()
            present.title = name
            present.price = priceString
            do {
                try realm.write({
                    self.realm.add(present)
                })
            } catch let error {
                error.localizedDescription
            }
            completion(nil)
        }
    }
}
