//
//  ViewController.swift
//  Task1Presents
//
//  Created by Andrew Cheberyako on 07.07.2021.
//

import UIKit
import RealmSwift

class PrizeListViewController: UIViewController {
    let viewModel = PrizeListViewModel()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countMoneyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        viewModel.items = viewModel.realm.objects(Prize.self)
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.generateDefaultData { error in
            guard error == nil else {
                error?.localizedDescription
                return
            }
            self.tableView.reloadData()
        }
        countMoneyLabel.text = String(viewModel.getTotalSelectedItemsPrice())
    }

    @IBAction func createNewPrizeAction(_ sender: Any) {
        performSegue(withIdentifier: "createNewPrize", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let newVC = segue.destination as? NewPrizeViewController else { return }
        newVC.delegate = self
    }
}

extension PrizeListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else { fatalError() }
        let item = viewModel.items[indexPath.row]
        cell.namePresentLabel.text = item.title
        cell.pricePresentLabel.text = "Цена \(String(item.price))"
        if item.selected == false {
            cell.imageCheck.image = UIImage(systemName: "checkmark.circle")
        } else {
            cell.imageCheck.image = UIImage(systemName: "checkmark.circle.fill")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let editingRow = viewModel.items[indexPath.row]
        if editingStyle == .delete {
            viewModel.deleteItem(editingRow: editingRow) {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.countMoneyLabel.text = String(self.viewModel.getTotalSelectedItemsPrice())
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editingRow = viewModel.items[indexPath.row]
        viewModel.checkLimit(label: countMoneyLabel, editingRow: editingRow) {
            tableView.reloadData()
        }
    }
}

extension PrizeListViewController: NewPrizeControllerDelegate {
    func didCreateNewPrize() {
        tableView.reloadData()
    }
}
