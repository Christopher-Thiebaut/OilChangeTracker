//
//  VehicleTableViewController.swift
//  OilChangeTracker
//
//  Created by Christopher Thiebaut on 4/22/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class VehicleTableViewController: UITableViewController {
    
    let vehicleController = VehicleController.default
    private let cellReuseID = VehicleTableViewCell.preferredReuseID

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func setupTableView(){
        let nib = UINib(nibName: VehicleTableViewCell.nibName, bundle: Bundle(for: type(of: self)))
        tableView.register(nib, forCellReuseIdentifier: cellReuseID)
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = vehicleController.vehicles.count
        if count == 0 {
            let noVehiclesLabel = UILabel(frame: CGRect(origin: CGPoint.zero, size: tableView.frame.size))
            noVehiclesLabel.lineBreakMode = .byWordWrapping
            noVehiclesLabel.numberOfLines = 0
            noVehiclesLabel.text = "You have no saved vehicles.  \nAdd one to get started."
            noVehiclesLabel.textAlignment = .center
            tableView.backgroundView = noVehiclesLabel
            NSLayoutConstraint(item: noVehiclesLabel, attribute: .width, relatedBy: .equal, toItem: tableView, attribute: .width, multiplier: 1, constant: 8).isActive = true
            tableView.separatorStyle = .none
        }else{
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
        return vehicleController.vehicles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID) as? VehicleTableViewCell else {
            NSLog("Unexpected cell type for reuse ID: \(cellReuseID)")
            fatalError()
        }
        let vehicle = vehicleController.vehicles[indexPath.row]
        cell.displayVehicle(vehicle)
        
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let vehicle = vehicleController.vehicles[indexPath.row]
            vehicleController.removeVehicle(vehicle)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }    
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toVehicleDetailViewController", sender: tableView.cellForRow(at: indexPath))
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vehicleDetailViewController = segue.destination as? VehicleDetailViewController, let selectedIndex = tableView.indexPathForSelectedRow?.row {
            let vehicle = vehicleController.vehicles[selectedIndex]
            vehicleDetailViewController.vehicle = vehicle
        }
    }

}
