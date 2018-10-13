//
//  Favorites-tableview.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/12/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import UIKit

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flightcell") as! FlightCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        // Initialize Cell
        cell.awakeFromNib()
        cell.initializeCellFrom(flight: favorites[indexPath.row], state: 2, expectedWidth: view.frame.width)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedFlight = favorites[indexPath.row]
        performSegue(withIdentifier: "favorite2flight", sender: self)
    }
    
    
    
    
}
