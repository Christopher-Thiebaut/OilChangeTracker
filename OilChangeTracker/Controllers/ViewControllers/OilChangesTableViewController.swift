//
//  OilChangesTableViewController.swift
//  OilChangeTracker
//
//  Created by Christopher Thiebaut on 5/17/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class OilChangesTableViewController: UITableViewController {
    
    var vehicleController = VehicleController.shared
    var oilChanges: [OilChange] = []
    let cellReuseID = OilChangeTableViewCell.cellClassName
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let containingBundle = Bundle(for: type(of: self))
        let oilChangeCellNib = UINib(nibName: cellReuseID, bundle: containingBundle)
        tableView.register(oilChangeCellNib, forCellReuseIdentifier: cellReuseID)
        hideEmptySeparators()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let vehicle = vehicleController.currentVehicle {
            oilChanges = vehicle.oilChanges
        }else{
            oilChanges = []
        }
        setupBackgroundView()
        tableView.reloadData()
    }
    
    private func setupBackgroundView(){
        if oilChanges.count > 0 {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }else{
            let noDataLabel = UILabel(frame: CGRect(origin: CGPoint.zero, size: tableView.frame.size))
            noDataLabel.text = "No oil changes recorded."
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
    }
    
    //Hides unnessary separators after last entry in table by adding an empty footer view.
    private func hideEmptySeparators(){
        let emptyView = UIView(frame: CGRect.zero)
        tableView.tableFooterView = emptyView
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oilChanges.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath)
        guard let oilChangeCell = cell as? OilChangeTableViewCell else { return cell }
        let oilChange = oilChanges[indexPath.row]
        oilChangeCell.displayOilChange(oilChange)
        return oilChangeCell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
