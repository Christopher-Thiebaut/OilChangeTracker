//
//  AllVehiclesViewController.swift
//  OilChangeTracker
//
//  Created by Christopher Thiebaut on 5/17/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class AllVehiclesViewController: UIViewController {
    
    var tableViewController: VehiclesTableViewController?
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vehiclesTableViewController = segue.destination as? VehiclesTableViewController {
            tableViewController = vehiclesTableViewController
        }
    }

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        if vehiclesTableViewIsEditing() {
            tableViewController?.finishEditing()
        }else{
            tableViewController?.enterEditingMode()
        }
        refreshEditButtonTitle()
    }
    
    private func vehiclesTableViewIsEditing() -> Bool {
        //If there is no tableview, it isn't editing
        return tableViewController?.tableView.isEditing ?? false
    }
    
    private func refreshEditButtonTitle(){
        if vehiclesTableViewIsEditing() {
            editButton.title = "Done"
        }else {
            editButton.title = "Edit"
        }
    }
    
}
