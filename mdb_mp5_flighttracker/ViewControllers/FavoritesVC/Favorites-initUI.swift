//
//  Favorites-initUI.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/12/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import UIKit

extension FavoritesViewController {
    func initUI() {
        self.title = "My Favorites"
        initTableView()
    }
    
    func initTableView() {
        favoritesList = UITableView(frame: CGRect(x: 0, y: (navigationController?.navigationBar.frame.maxY)!, width: view.frame.width, height: (tabBarController?.tabBar.frame.minY)! - (navigationController?.navigationBar.frame.maxY)!))
        favoritesList.register(FlightCell.self, forCellReuseIdentifier: "flightcell")
        favoritesList.delegate = self
        favoritesList.dataSource = self
        favoritesList.rowHeight = 80
        view.addSubview(favoritesList)
    }
}
