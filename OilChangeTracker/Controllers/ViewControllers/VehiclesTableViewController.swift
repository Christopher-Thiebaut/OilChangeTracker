//
//  VehiclesTableViewController.swift
//  OilChangeTracker
//
//  Created by Christopher Thiebaut on 5/15/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class VehiclesTableViewController: UITableViewController {
    
    var vehicleController: VehicleController = VehicleController.shared
    let cellReuseID = "VehicleCell"

    override func viewDidLoad() {
        super.viewDidLoad()

//         Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Add a blank footer to the tableview to hide extra lines after the last entry.
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicleController.vehicles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath)
        let vehicle = vehicleController.vehicles[indexPath.row]
        cell.textLabel?.text = vehicle.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vehicle = vehicleController.vehicles[indexPath.row]
        vehicleController.currentVehicle = vehicle
        navigationController?.popViewController(animated: true)
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let vehicle = vehicleController.vehicles[fromIndexPath.row]
        vehicleController.removeVehicleMatching(vehicle)
        vehicleController.addVehicle(vehicle, at: to.row)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
