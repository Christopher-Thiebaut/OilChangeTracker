//
//  VehicleDetailViewController.swift
//  OilChangeTracker
//
//  Created by Christopher Thiebaut on 4/25/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class VehicleDetailViewController: UIViewController {
    
    var vehicle: Vehicle?
    var vehicleController = VehicleController.default
    
    @IBOutlet weak var vehicleNameTextField: UITextField!
    @IBOutlet weak var oilChangeFrequencyTextField: UITextField!
    @IBOutlet weak var oilChangesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupForVehicle()
        oilChangesTableView.dataSource = self
        vehicleNameTextField.delegate = self
        oilChangeFrequencyTextField.delegate = self
    }

    private func setupForVehicle(){
        vehicleNameTextField.text = vehicle?.name
        if let vehicle = vehicle {
            oilChangeFrequencyTextField.text = "\(vehicle.oilChangeInterval)"
        }else{
            oilChangeFrequencyTextField.text = nil
        }
        setupTableViewBackground()
    }
    
    private func setupTableViewBackground(){
        if let vehicle = vehicle, vehicle.oilChanges.count > 0 {
            oilChangesTableView.separatorStyle = .singleLine
            oilChangesTableView.backgroundView = nil
        }else{
            let noDataLabel = UILabel(frame: oilChangesTableView.frame)
            noDataLabel.text = "No oil changes recorded for this vehicle yet!"
            noDataLabel.lineBreakMode = .byWordWrapping
            noDataLabel.numberOfLines = 0
            noDataLabel.textAlignment = .center
            noDataLabel.translatesAutoresizingMaskIntoConstraints = false
            oilChangesTableView.backgroundView = noDataLabel
            NSLayoutConstraint(item: noDataLabel, attribute: .leading, relatedBy: .equal, toItem: oilChangesTableView, attribute: .leading, multiplier: 1, constant: -16).isActive = true
            NSLayoutConstraint(item: noDataLabel, attribute: .trailing, relatedBy: .equal, toItem: oilChangesTableView, attribute: .trailing, multiplier: 1, constant: 16).isActive = true
            NSLayoutConstraint(item: noDataLabel, attribute: .centerX, relatedBy: .equal, toItem: oilChangesTableView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: noDataLabel, attribute: .centerY, relatedBy: .equal, toItem: oilChangesTableView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            oilChangesTableView.separatorStyle = .none
        }
    }
    
    fileprivate func textFieldUpdated(){
        let chosenVehicleName = vehicleNameTextField.text == "" ? nil : vehicleNameTextField.text
        var chosenOilChangeInterval: Double? = nil
        if let oilChangeIntervalText = oilChangeFrequencyTextField.text {
            chosenOilChangeInterval = Double(oilChangeIntervalText)
        }
        if let vehicle = vehicle {
            if let name = chosenVehicleName, let oilChangeInterval = chosenOilChangeInterval {
                vehicleController.updateVehicle(vehicle, withName: name, andOilChangeInterval: oilChangeInterval)
            }
        }else{
            if let name = chosenVehicleName, let oilChangeInterval = chosenOilChangeInterval {
               vehicle = vehicleController.addVehicle(withName: name, oilChangeInterval: oilChangeInterval)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doneButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension VehicleDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicle?.oilChanges.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

extension VehicleDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        textFieldUpdated()
    }
}
