//
//  VehicleEditorViewController.swift
//  OilChangeTracker
//
//  Created by Christopher Thiebaut on 5/21/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class VehicleEditorViewController: UIViewController, EditorViewController {

    @IBOutlet weak var vehicleNameTextField: UITextField!
    @IBOutlet weak var monthsBetweenOilChangesTextField: UITextField!
    @IBOutlet weak var odometerReadingTextField: UITextField!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    let newVehicleSaveButtonText = "Done"
    let oldVehicleSaveButtonText = "Save"
    let newVehicleDeleteButtonText = "Cancel"
    let oldVehicleDeleteButtonText = "Delete"
    let secondsPerMonth: TimeInterval = 60*60*24*30
    
    var vehicle: Vehicle?
    var vehicleController = VehicleController.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setButtonText()
        if let vehicle = vehicle {
            setupFields(for: vehicle)
        }else{
            clearTextFields()
        }
        hideBackNavigationIfFirstVehicle()
    }
    
    private func setButtonText(){
        if vehicle != nil {
            deleteButton.setTitle(oldVehicleDeleteButtonText, for: .normal)
            saveButton.setTitle(oldVehicleSaveButtonText, for: .normal)
        }else{
            deleteButton.setTitle(newVehicleDeleteButtonText, for: .normal)
            saveButton.setTitle(newVehicleSaveButtonText, for: .normal)
        }
    }
    
    private func setupFields(for vehicle: Vehicle){
        vehicleNameTextField.text = vehicle.name
        monthsBetweenOilChangesTextField.text = "\(Int(vehicle.timeIntervalBetweenOilChanges/secondsPerMonth))"
        odometerReadingTextField.text = "\(vehicle.odometerReading)"
    }
    
    private func clearTextFields(){
        vehicleNameTextField.text = nil
        monthsBetweenOilChangesTextField.text = nil
        odometerReadingTextField.text = nil
    }
    
    private func hideBackNavigationIfFirstVehicle(){
        let noVehiclesExist = vehicleController.vehicles.count < 1
        navigationItem.hidesBackButton = noVehiclesExist
        deleteButton.isHidden = noVehiclesExist
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
        if let vehicle = vehicle {
            vehicleController.removeVehicleMatching(vehicle)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let monthsBetweenOilChanges = getNumberFromTextField(monthsBetweenOilChangesTextField), let odometerReading = getNumberFromTextField(odometerReadingTextField), let vehicleName = vehicleNameTextField.text, !vehicleName.isEmpty else {
            notifyUserOfInvalidInput()
            return
        }
        let secondsBetweenOilChanges = monthsBetweenOilChanges * secondsPerMonth
        if let vehicle = vehicle {
            vehicleController.updateNameOfVehicle(vehicle, to: vehicleName)
            vehicleController.updateMileageOfVehicle(vehicle, to: odometerReading)
            vehicleController.updateTimeIntervalBetweenOilChanges(vehicle, to: secondsBetweenOilChanges)
        }else{
            let vehicle = Vehicle(name: vehicleName, timeIntervalBetweenOilChanges: secondsBetweenOilChanges, odometerReading: odometerReading)
            vehicleController.addVehicle(vehicle)
        }
        navigationController?.popViewController(animated: true)
    }
    
}
