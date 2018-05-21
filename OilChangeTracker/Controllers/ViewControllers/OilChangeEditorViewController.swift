//
//  OilChangeEditorViewController.swift
//  OilChangeTracker
//
//  Created by Christopher Thiebaut on 5/20/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class OilChangeEditorViewController: UIViewController {

    @IBOutlet private weak var odometerTextField: UITextField!
    @IBOutlet private weak var dateTextField: UITextField!
    @IBOutlet private weak var oilLifeTextField: UITextField!
    @IBOutlet private weak var filterLifeTextField: UITextField!
    @IBOutlet private weak var locationTextField: UITextField!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    private let newOilChangeDeleteText = "Cancel"
    private let oldOilChangeDeleteText = "Delete"
    private let newOilChangeSaveText = "Done"
    private let oldOilChangeSaveText = "Save"
    
    var oilChange: OilChange?
    var vehicleController = VehicleController.shared
    
    private var newOilChangeDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        becomeDelegateOfTextFields()
        setButtonText()
        setupDateFieldInputView()
        setupKeyboardDismissalTapGestureRecognizer()
        setInitialTextFieldContents()
    }
    
    private func becomeDelegateOfTextFields(){
        odometerTextField.delegate = self
        dateTextField.delegate = self
        oilLifeTextField.delegate = self
        filterLifeTextField.delegate = self
        locationTextField.delegate = self
    }
    
    private func setInitialTextFieldContents(){
        guard let oilChange = oilChange else { return }
        odometerTextField.text = "\(oilChange.odometerReading)"
        dateTextField.text = "\(oilChange.date.description)"
        oilLifeTextField.text = "\(oilChange.oilLife)"
        filterLifeTextField.text = "\(oilChange.filterLife)"
        locationTextField.text = oilChange.location
    }
    
    private func setButtonText(){
        if oilChange != nil {
            deleteButton.setTitle(oldOilChangeDeleteText, for: .normal)
            saveButton.setTitle(oldOilChangeSaveText, for: .normal)
        }else{
            deleteButton.setTitle(newOilChangeDeleteText, for: .normal)
            saveButton.setTitle(newOilChangeSaveText, for: .normal)
        }
    }
    
    private func setupDateFieldInputView(){
        let datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.addTarget(self, action: #selector(dateChosen), for: .valueChanged)
        dateTextField.inputView = datePicker
        dateChosen()
    }
    
    @objc private func dateChosen(){
        guard let datePicker = dateTextField.inputView as? UIDatePicker else {
            return
        }
        dateTextField.text = datePicker.date.description
        newOilChangeDate = datePicker.date
    }
    
    private func setupKeyboardDismissalTapGestureRecognizer(){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(false)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if let oilChange = oilChange, let vehicle = vehicleController.currentVehicle {
            vehicleController.removeOilChange(oilChange, from: vehicle)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let odometer = getNumberFromTextField(odometerTextField), let oilLife = getNumberFromTextField(oilLifeTextField), let filterLife = getNumberFromTextField(filterLifeTextField) else {
            notifyUserOfInvalidInput()
            return
        }
        guard let currentVehicle = vehicleController.currentVehicle else {
            return
        }
        if let existingOilChange = oilChange {
            vehicleController.updateOdometerReading(for: existingOilChange, to: odometer)
            vehicleController.updateDate(for: existingOilChange, to: newOilChangeDate)
            vehicleController.updateFilterLife(for: existingOilChange, to: filterLife)
            vehicleController.updateOilLife(for: existingOilChange, to: oilLife)
            vehicleController.updateLocation(for: existingOilChange, to: locationTextField.text ?? "")
        }else{
            let oilChangeToSave = OilChange(odometerReading: odometer, date: newOilChangeDate, oilLife: oilLife, filterLife: filterLife, location: locationTextField.text ?? "")
            vehicleController.addOilChange(oilChangeToSave, to: currentVehicle)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func getNumberFromTextField(_ textField: UITextField) -> Double? {
        guard let fieldText = textField.text else {
            return nil
        }
        return Double(fieldText)
    }
    
    private func notifyUserOfInvalidInput() {
        let missingInputAlert = UIAlertController(title: "All fields are required.", message: "Please complete the entire form.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        missingInputAlert.addAction(okAction)
        present(missingInputAlert, animated: true, completion: nil)
    }
    
}

extension OilChangeEditorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let numericTextFields: Set<UITextField> = [odometerTextField, oilLifeTextField, filterLifeTextField]
        if numericTextFields.contains(textField) {
            var numberChars = CharacterSet.decimalDigits
            numberChars.insert(".")
            let replacementCharacters = CharacterSet.init(charactersIn: string)
            let textFieldContainsDecimal = textField.text?.contains(".") ?? false
            return numberChars.isSuperset(of: replacementCharacters) && (!textFieldContainsDecimal || !replacementCharacters.contains("."))
        }else{
            return true
        }
    }
}
