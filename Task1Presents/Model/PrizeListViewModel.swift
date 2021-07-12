//
//  Model.swift
//  Task1Presents
//
//  Created by Andrew Cheberyako on 08.07.2021.
//

import Foundation
import RealmSwift

enum PriceCalculationsError: String, Error {
    case highPrice = "Слишком большая цена, меньшая или равная 0"
    case priceNotInt = "Вводите только цифры в поле цены"
}

class PrizeListViewModel {
    let maxSumLimit = 100
    let realm = try! Realm()
    var items: Results<Prize>!
    
    func generateDefaultData(completion: @escaping(Error?) -> Void) {
        guard realm.isEmpty else { return }
        let iphone = Prize(value: ["iPhone", 10, false])
        let ipad = Prize(value: ["iPad", 20, false])
        let imac = Prize(value: ["iMac", 20, false])
        let ipod = Prize(value: ["ipod", 10, false])
        let ipod2 = Prize(value: ["ipod2", 10, false])
        let ipod3 = Prize(value: ["ipod3", 10, false])
        let ipod4 = Prize(value: ["ipod4", 10, false])
        let iphone1 = Prize(value: ["iPhone", 10, false])
        let ipad1 = Prize(value: ["iPad", 20, false])
        let imac1 = Prize(value: ["iMac", 20, false])
        let ipod1 = Prize(value: ["ipod", 10, false])
        let ipod21 = Prize(value: ["ipod2", 10, false])
        let ipod31 = Prize(value: ["ipod3", 10, false])
        let ipod41 = Prize(value: ["ipod4", 10, false])
        do {
            try realm.write({
                realm.add([iphone, ipad, imac, ipod, ipod2, ipod3, ipod4, iphone1, ipad1, imac1, ipod21, ipod31, ipod41, ipod1])
                completion(nil)
            })
        } catch let error {
            completion(error)
        }
    }

    func getTotalSelectedItemsPrice() -> Int {
        getSelectedPricesArray().reduce(0, +)
    }
    
    func getSelectedPricesArray() -> [Int] {
        realm.objects(Prize.self).filter("selected = true").map { $0.price }
    }
    
    func removeItemsOverLimit(difference: Int) -> String? {
        let items = items.filter("selected = true")
        var selectedPrizesCount = items.count - 1
        var sum = getTotalSelectedItemsPrice() + difference
        while 0 <= selectedPrizesCount {
            if sum > maxSumLimit {
                do {
                try realm.write({
                    if selectedPrizesCount == 0 {
                        items[0].selected = !items[0].selected
                        realm.add(items, update: .modified)
                    } else {
                        items[0].selected = !items[0].selected
                        realm.add(items[0], update: .modified)
                    }
                })
                } catch let error {
                    error.localizedDescription
                }
                sum = getTotalSelectedItemsPrice() + difference
                if sum > maxSumLimit {
                    selectedPrizesCount = getSelectedPricesArray().count - 1
                } else {
                    return String(sum)
                }
            } else {
                break
            }
        }
        let stringSumValue = String(sum)
        return stringSumValue
    }
    
    func checkLimit(label: UILabel, editingRow: Prize, completion: @escaping() -> Void) {
        
        if (getTotalSelectedItemsPrice() + editingRow.price) > maxSumLimit && editingRow.selected == false {
            label.text = removeItemsOverLimit(difference: editingRow.price)
        }
        if editingRow.selected == false &&  (getTotalSelectedItemsPrice() + editingRow.price) <= maxSumLimit {
            do {
            try realm.write({
                editingRow.selected = true
                label.text = String(getTotalSelectedItemsPrice())
            })
            } catch let error {
                error.localizedDescription
            }
        } else {
            do {
            try realm.write({
                editingRow.selected = !editingRow.selected
                label.text = String(getTotalSelectedItemsPrice())
            })
            } catch let error {
                error.localizedDescription
            }
        }
        completion()
    }
    
    func deleteItem(editingRow: Prize, completin: @escaping() -> Void ) {
        do {
            try self.realm.write({
                self.realm.delete(editingRow)
            })
            completin()
        } catch let error {
            error.localizedDescription
        }
    }
    
}
