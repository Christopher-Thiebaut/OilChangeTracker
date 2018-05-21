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
    let toOilChangeEditorSegueID = "toOilChangeEditor"
    
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
    
    ///Hides unnessary separators after last entry in table by adding an empty footer view.
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

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let vehicle = vehicleController.currentVehicle else { return }
        if editingStyle == .delete {
            let oilChange = oilChanges[indexPath.row]
            vehicleController.removeOilChange(oilChange, from: vehicle)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: toOilChangeEditorSegueID, sender: tableView.cellForRow(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let oilChangeEditor = segue.destination as? OilChangeEditorViewController, let oilChangeIndex = tableView.indexPathForSelectedRow?.row else {
            return
        }
        let selectedOilChange = oilChanges[oilChangeIndex]
        oilChangeEditor.oilChange = selectedOilChange
    }

}
