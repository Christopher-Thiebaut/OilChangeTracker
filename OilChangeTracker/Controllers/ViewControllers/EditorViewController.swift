//
//  EditorViewController.swift
//  OilChangeTracker
//
//  Created by Christopher Thiebaut on 5/21/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

protocol EditorViewController where Self: UIViewController {
    func getNumberFromTextField(_ textField: UITextField) -> Double?
    func notifyUserOfInvalidInput()
}

extension EditorViewController {
    func getNumberFromTextField(_ textField: UITextField) -> Double? {
        guard let fieldText = textField.text else {
            return nil
        }
        return Double(fieldText)
    }
    
    func notifyUserOfInvalidInput() {
        let missingInputAlert = UIAlertController(title: "All fields are required.", message: "Please complete the entire form.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        missingInputAlert.addAction(okAction)
        present(missingInputAlert, animated: true, completion: nil)
    }
}
