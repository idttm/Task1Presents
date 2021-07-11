//
//  Model.swift
//  Task1Presents
//
//  Created by Andrew Cheberyako on 08.07.2021.
//

import Foundation
import RealmSwift

enum MyError: String {
    
    case highPrice = "Слишком большая цена, меньшая или равная 0"
    
}

class Model {
    
    let realm = try! Realm()
    var items: Results<PrizeList>!
    
    func defaultData(completion: @escaping() -> Void) {
        
        let iphone = PrizeList(value: ["iPhone", 10, false])
        let ipad = PrizeList(value: ["iPad", 20, false])
        let imac = PrizeList(value: ["iMac", 20, false])
        let ipod = PrizeList(value: ["ipod", 10, false])
        let ipod2 = PrizeList(value: ["ipod2", 10, false])
        let ipod3 = PrizeList(value: ["ipod3", 10, false])
        let ipod4 = PrizeList(value: ["ipod4", 10, false])
        let iphone1 = PrizeList(value: ["iPhone", 10, false])
        let ipad1 = PrizeList(value: ["iPad", 20, false])
        let imac1 = PrizeList(value: ["iMac", 20, false])
        let ipod1 = PrizeList(value: ["ipod", 10, false])
        let ipod21 = PrizeList(value: ["ipod2", 10, false])
        let ipod31 = PrizeList(value: ["ipod3", 10, false])
        let ipod41 = PrizeList(value: ["ipod4", 10, false])
        
        if realm.isEmpty {
        try! realm.write({
            realm.add([iphone, ipad, imac, ipod, ipod2, ipod3, ipod4, iphone1, ipad1, imac1, ipod21, ipod31, ipod41, ipod1])
        })
        completion()
        } else {
            print("can only be done once")
        }
        
    }
    
    func addNewPresent(name: String, price: String) {
        guard let priceInt = Int(price) else {return}
        let present = PrizeList()
        present.namePrize = name
        present.prise = priceInt
        try! realm.write({
            self.realm.add(present)
        })
    }
    
    func countPrice() -> Int {
        let arrayPrice = arraySelectedPrice()
        let sum = arrayPrice.reduce(0, +)
        return sum
    }
    
    func arraySelectedPrice() -> [Int]   {
        let items = realm.objects(PrizeList.self).filter("selected = true")
        var arrayPrice: [Int] {
            get {
                return items.map { $0.prise }
            }
        }
        return arrayPrice
    }
    
    func removalOfOverLimit (difference: Int) -> String? {
        
        let items = realm.objects(PrizeList.self).filter("selected = true")
        var countSelectedPrice = items.count - 1
        let i = 0
        var sum = countPrice() + difference
        while i <= countSelectedPrice {
            if sum > 100 {
                try! realm.write({
                    if countSelectedPrice == 0 {
                        items[0].selected = !items[0].selected
                        realm.add(items, update: .modified)
                    } else {
                        items[i].selected = !items[i].selected
                        realm.add(items[i], update: .modified)
                    }
                })
                sum = countPrice() + difference
                if sum > 100 {
                    countSelectedPrice = arraySelectedPrice().count - 1
                    print(countSelectedPrice)
                } else {
                    return String(sum)
                }
            }
            else {
                break
            }
        }
        let stringSumValue = String(sum)
        return stringSumValue
    }
    
    func limitCheck(label: UILabel, editingRow: PrizeList, completion: @escaping() -> Void) {
        
        if (countPrice() + editingRow.prise) > 100 && editingRow.selected == false {
            label.text = removalOfOverLimit(difference: editingRow.prise)
        }
        if editingRow.selected == false &&  (countPrice() + editingRow.prise) <= 100 {
            try! realm.write({
                editingRow.selected = true
                label.text = String(countPrice())
            })
        } else {
            try! realm.write({
                editingRow.selected = !editingRow.selected
                label.text = String(countPrice())
            })
        }
        completion()
    }
    
    func deleteItem(label: UILabel, editingRow: PrizeList, indexPath: IndexPath, tableView: UITableView) {
        try! self.realm.write({
            self.realm.delete(editingRow)
        })
        tableView.deleteRows(at: [indexPath], with: .automatic)
        label.text = String(countPrice())
    }
    
}
