//
//  MyAlertController.swift
//  Task1Presents
//
//  Created by Andrew Cheberyako on 11.07.2021.
//
import UIKit

extension UIViewController {
    func showAlert(with title: String, and massage: String) {
        let alertController = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
