//
//  NewPresentViewController.swift
//  Task1Presents
//
//  Created by Andrew Cheberyako on 07.07.2021.
//

import UIKit

class NewPresentViewController: UIViewController {
    
    var model = Model()
    
    @IBOutlet weak var namePresentLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var sameButtonOutlet: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButtonState()
        model.items = model.realm.objects(PrizeList.self)
    }

    @IBAction func buttonAciotn(_ sender: UIBarButtonItem) {
        
        guard let priceText = priceTextField.text else {return}
        guard let nameText = nameTextField.text else {return}
        guard let priceTextInt = Int(priceText) else {return}
        if priceTextInt >= 100 || priceTextInt <= 0 {
            self.showAlert(with: "Ошибка", and: MyError.highPrice.rawValue)
            priceTextField.text = ""
        } else {
            model.addNewPresent(name: nameText, price: priceText)
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    private func updateSaveButtonState() {
        let name = nameTextField.text ?? ""
        let price = priceTextField.text ?? ""
        sameButtonOutlet.isEnabled = !name.isEmpty && !price.isEmpty
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
}
