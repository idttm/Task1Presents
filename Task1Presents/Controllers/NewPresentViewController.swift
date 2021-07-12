//
//  NewPresentViewController.swift
//  Task1Presents
//
//  Created by Andrew Cheberyako on 07.07.2021.
//

import UIKit

protocol NewPrizeControllerDelegate: AnyObject {
    func didCreateNewPrize()
}

class NewPrizeViewController: UIViewController {
    
    weak var delegate: NewPrizeControllerDelegate?
    var viewModel = NewPrizeModel()
    
    @IBOutlet weak var presentTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var saveButtonOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButtonState()
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let priceText = priceTextField.text,
              let nameText = titleTextField.text
        else { return }
        if let priceInt = Int(priceText) {
            viewModel.addNewPresent(name: nameText, priceInt: priceInt) { error in
                if error != nil {
                    self.showAlert(with: "Ошибка", and: PriceCalculationsError.highPrice.rawValue )
                    self.priceTextField.text = ""
                    self.updateSaveButtonState()
                } else {
                    self.delegate?.didCreateNewPrize()
                    self.navigationController?.popViewController(animated: false)
                }
            }
        }
        else {
            self.showAlert(with: "Ошибка", and: PriceCalculationsError.priceNotInt.rawValue)
        }
        
    }
    
    private func updateSaveButtonState() {
        let name = titleTextField.text ?? ""
        let price = priceTextField.text ?? ""
        saveButtonOutlet.isEnabled = !name.isEmpty && !price.isEmpty
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
}
