//
//  ViewController.swift
//  Task1Presents
//
//  Created by Andrew Cheberyako on 07.07.2021.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    let model = Model()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countMoneyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        model.items = model.realm.objects(PrizeList.self)
        countMoneyLabel.text = String(model.countPrice())
        tableView.delegate = self
        tableView.dataSource = self
        model.defaultData {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {fatalError()}
        let item = model.items[indexPath.row]
        cell.namePresentLabel.text = item.namePrize
        cell.pricePresentLabel.text = "Цена \(String(item.prise))"
        if item.selected == false {
            cell.imageCheck.image = UIImage(systemName: "checkmark.circle")
        } else {
            cell.imageCheck.image = UIImage(systemName: "checkmark.circle.fill")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let editingRow = model.items[indexPath.row]
        if editingStyle == .delete {
            try! self.model.realm.write({
                self.model.realm.delete(editingRow)
            })
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            countMoneyLabel.text = String(model.countPrice())
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let editingRow = model.items[indexPath.row]
        
        model.limitCheck(label: countMoneyLabel, editingRow: editingRow) {
            tableView.reloadData()
        }
    }
}

