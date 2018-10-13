//
//  FlightInfo-initUI.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/10/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension FlightInfoViewController {
    func initUI() {
        initNav()
        initMap()
        initPane()
        animationDistance = (tabBarController?.tabBar.frame.minY)! - timingPane.frame.minY
        initSwiper()
    }
    
    // General Inits
    func initPane() {
        let height = heightOfPane - 2 * Constants.PADDING
        pane = UIView(frame: CGRect(x: Constants.PADDING/2, y: view.frame.height - height, width: view.frame.width - Constants.PADDING, height: height))
        pane.backgroundColor = .white
        pane.alpha = 0.9
        pane.layer.cornerRadius = 10
        pane.layer.shadowColor = UIColor.black.cgColor
        pane.layer.shadowOpacity = 0.7
        pane.layer.shadowOffset = CGSize(width: 1, height: 1)
        pane.layer.shadowRadius = 20
        pane.layer.shouldRasterize = true
        view.addSubview(pane)
        // Add elements to the pane
        addStatusAndNumber()
        addTimings()
        addAirports()
        addAirplane()
        addGates()
        
    }
    func initNav() {
        self.title = FLIGHT.id
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(addToFavorites))
    }
    @objc func addToFavorites() {
        var arr = LocalData.getLocalDataAsArr(forKey: .favorites) ?? []
        debugPrint(arr)
        let getURL = [Constants.FLIGHT_STATUS, FLIGHT.id, FLIGHT.dateString].joined(separator: "/")
        
        var tit = ""
        var alertmsg = ""
        if arr.contains(getURL) {
            tit = "Success!"
            alertmsg = "Removed this flight from your favorites."
            arr.remove(at: arr.index(of: getURL)!)
            LocalData.putLocalData(forKey: .favorites, data: arr)
        } else if (arr.count == 5) {
            tit = "Oops"
            alertmsg = "Sorry, you can only have 5 flights in your favorites. Go to a favorited flight and tap to remove."
        } else {
            arr.append(getURL)
            LocalData.putLocalData(forKey: .favorites, data: arr)
            tit = "Saved!"
            alertmsg = "This flight has been added to favorites"
        }
        AlertManager(view: self).displayAlert(title: tit, message: alertmsg)
        
    }
    
    
    // Pane Initializations
    func addStatusAndNumber() {
        flightStatus = UILabel(frame: CGRect(x: pane.frame.minX, y: pane.frame.minY+Constants.PADDING/2, width: pane.frame.width, height: 30))
        flightStatus.text = FLIGHT.status
        flightStatus.textAlignment = .center
        flightStatus.font = UIFont(name: "Avenir-Heavy", size: 22)
        flightStatus.textColor = .black
        view.addSubview(flightStatus)
        
        
        
        flightNumber = UILabel(frame: LayoutManager.belowCentered(elementAbove: flightStatus, padding: -5, width: pane.frame.width, height: 30))
        let text = FLIGHT.id.replacingOccurrences(of: "LH", with: "Lufthansa Airlines ")
        flightNumber.text = text
        flightNumber.textAlignment = .center
        flightNumber.font = UIFont(name: "Avenir-Roman", size: 14)
        flightNumber.textColor = Constants.DEEP_BLUE
        view.addSubview(flightNumber)
    }
    
    func addTimings() {
        timingPane = UIView(frame: LayoutManager.belowCentered(elementAbove: flightNumber, padding: 0, width: pane.frame.width, height: 120))
        timingPane.backgroundColor = Constants.DEEP_BLUE
        view.addSubview(timingPane)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        // Scheduled
        struct timingVisual {
            var date: Date
            var title: String
        };
        
        var left:[timingVisual] = []
        if let leftBig = FLIGHT.departActual {
            left.append(timingVisual(date: leftBig, title: "Actual"))
        }
        left.append(timingVisual(date: FLIGHT.departScheduled, title: "Scheduled"))
        
        var right:[timingVisual] = []
        if let rightBig = FLIGHT.arriveActual {
            right.append(timingVisual(date: rightBig, title: "Actual"))
        }
        right.append(timingVisual(date: FLIGHT.arriveScheduled, title: "Scheduled"))
        
        
        var labelTemplate = UILabel(frame: CGRect.zero)
            
        
        labelTemplate.textAlignment = .center
        labelTemplate.adjustsFontSizeToFitWidth = true
        labelTemplate.textColor = .white
        labelTemplate.font = Constants.TEXT_FONT
        
        var currTiming = left.removeFirst()
        bigDepart = UILabel(frame: CGRect(x: pane.frame.minX + Constants.PADDING, y: timingPane.frame.minY + Constants.PADDING, width: pane.frame.width/2 - 2 * Constants.PADDING, height: 60))
        bigDepart.text = formatter.string(for: currTiming.date)
        bigDepart.textAlignment = .center
        bigDepart.adjustsFontSizeToFitWidth = true
        bigDepart.textColor = .white
        bigDepart.font = Constants.HEADER_FONT
    
        labelTemplate = UILabel(frame: LayoutManager.aboveCentered(elementBelow: bigDepart, padding: -10, width: bigDepart.frame.width, height: 20))
        formatLabel(label: labelTemplate)
        labelTemplate.text = currTiming.title
        view.addSubview(bigDepart)
        view.addSubview(labelTemplate)
        
        currTiming = right.removeFirst()
        bigArrive = UILabel(frame: CGRect(x: pane.frame.midX + Constants.PADDING, y: timingPane.frame.minY + Constants.PADDING, width: pane.frame.width/2 - 2 * Constants.PADDING, height: 60))
        bigArrive.text = formatter.string(from: currTiming.date)
        bigArrive.textAlignment = .center
        bigArrive.adjustsFontSizeToFitWidth = true
        bigArrive.textColor = .white
        bigArrive.font = Constants.HEADER_FONT
        
        labelTemplate = UILabel(frame: LayoutManager.aboveCentered(elementBelow: bigArrive, padding: -10, width: bigArrive.frame.width, height: 20))
        formatLabel(label: labelTemplate)
        labelTemplate.text = currTiming.title
        view.addSubview(bigArrive)
        view.addSubview(labelTemplate)

        if left.count == 1 {
            currTiming = left.removeFirst()
            smallDepart = UILabel(frame: CGRect(x: pane.frame.minX + Constants.PADDING, y: timingPane.frame.maxY-(20+Constants.MARGINAL_PADDING), width: pane.frame.width/2 - 2 * Constants.PADDING, height: 20))
            smallDepart!.text = "\(currTiming.title): \(formatter.string(for: currTiming.date) ?? "--")"
            smallDepart!.textAlignment = .center
            smallDepart!.adjustsFontSizeToFitWidth = true
            smallDepart!.textColor = .white
            smallDepart!.font = Constants.TEXT_FONT
            view.addSubview(smallDepart!)
        }
        
        if right.count == 1 {
            currTiming = right.removeFirst()
            smallArrive = UILabel(frame: CGRect(x: pane.frame.midX + Constants.PADDING, y: timingPane.frame.maxY-(20+Constants.MARGINAL_PADDING), width: pane.frame.width/2 - 2 * Constants.PADDING, height: 20))
            smallArrive!.text = "\(currTiming.title): \(formatter.string(for: currTiming.date) ?? "--")"
            smallArrive!.textAlignment = .center
            smallArrive!.adjustsFontSizeToFitWidth = true
            smallArrive!.textColor = .white
            smallArrive!.font = Constants.TEXT_FONT
            view.addSubview(smallArrive!)
        }
        
        // add the arrow
        
        let arrowView = UIImageView(frame: CGRect(x: pane.frame.midX - Constants.PADDING/2, y: timingPane.frame.midY - Constants.PADDING/2, width: Constants.PADDING, height: Constants.PADDING))
        arrowView.image = UIImage(named: "arrow-white")
        arrowView.contentMode = .scaleAspectFit
        view.addSubview(arrowView)
        
        
    }
    
    func formatLabel(label: UILabel) {
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.font = Constants.TEXT_FONT
    }
    
    func addAirports() {
        srcAirportCode = UILabel(frame: CGRect(x: pane.frame.minX + Constants.PADDING, y: timingPane.frame.maxY + Constants.MARGINAL_PADDING, width: pane.frame.width/2 - 2 * Constants.PADDING, height: 30))
        srcAirportCode.text = FLIGHT.departingAirport.airportCode
        srcAirportCode.textAlignment = .right
        srcAirportCode.font = Constants.SUBTITLE_FONT
        view.addSubview(srcAirportCode)
        
        desAirportCode = UILabel(frame: CGRect(x: pane.frame.midX + Constants.PADDING, y: timingPane.frame.maxY + Constants.MARGINAL_PADDING, width: pane.frame.width/2 - 2 * Constants.PADDING, height: 30))
        desAirportCode.text = FLIGHT.arrivingAirport.airportCode
        desAirportCode.textAlignment = .left
        desAirportCode.font = Constants.SUBTITLE_FONT
        view.addSubview(desAirportCode)
        
        airportArrow = UIImageView(frame: CGRect(x: pane.frame.midX - Constants.PADDING/2, y: srcAirportCode.frame.midY - Constants.PADDING/2, width: Constants.PADDING, height: Constants.PADDING))
        airportArrow.image = UIImage(named: "arrow-black")
        airportArrow.contentMode = .scaleAspectFit
        view.addSubview(airportArrow)
    }
    
    func addAirplane() {
        plane = UIImageView(frame: LayoutManager.belowCentered(elementAbove: airportArrow, padding: 0, width: pane.frame.width - 2 * Constants.PADDING, height: 60))
        plane.image = FLIGHT.planeType.image
        plane.contentMode = .scaleAspectFit
        view.addSubview(plane)
        
        planeName = UILabel(frame: LayoutManager.belowCentered(elementAbove: plane, padding: 0, width: pane.frame.width, height: 30))
        planeName.text = FLIGHT.planeType.identifier
        planeName.textAlignment = .center
        planeName.font = Constants.TEXT_FONT
        view.addSubview(planeName)
        
        
        view.addSubview(Utils.getBottomBorder(forView: planeName, thickness: 1, color: rgba(200,200,200,0.9)))
        
        
    }

    func addGates() {
        
        
        departTermGate = UILabel(frame: CGRect(x: pane.frame.minX + Constants.PADDING, y: (tabBarController?.tabBar.frame.minY)! - (20 + Constants.MARGINAL_PADDING), width: pane.frame.width/2 - 2 * Constants.PADDING, height: 20))
        departTermGate.text = "\(FLIGHT.departTerm!)/\(FLIGHT.departGate!)"
        departTermGate.textAlignment = .left
        departTermGate.font = Constants.SUBTITLE_FONT
        departTermGate.textColor = .black
        view.addSubview(departTermGate)
        
        var termGateLabel = UILabel(frame: LayoutManager.aboveLeft(elementBelow: departTermGate, padding: 0, width: departTermGate.frame.width, height: 20))
        termGateLabel.text = "Departure"
        formatLabel(label: termGateLabel)
        termGateLabel.textAlignment = .left
        termGateLabel.textColor = .black
        view.addSubview(termGateLabel)
        
        arriveTermGate = UILabel(frame: CGRect(x: pane.frame.midX + Constants.PADDING, y: (tabBarController?.tabBar.frame.minY)! - (20 + Constants.MARGINAL_PADDING), width: pane.frame.width/2 - 2 * Constants.PADDING, height: 20))
        arriveTermGate.text = "\(FLIGHT.arriveTerm!)/\(FLIGHT.arriveTerm!)"
        arriveTermGate.textAlignment = .right
        arriveTermGate.font = Constants.SUBTITLE_FONT
        arriveTermGate.textColor = .black
        view.addSubview(arriveTermGate)
        
        termGateLabel = UILabel(frame: LayoutManager.aboveLeft(elementBelow: arriveTermGate, padding: 0, width: arriveTermGate.frame.width, height: 20))
        termGateLabel.text = "Arrival"
        formatLabel(label: termGateLabel)
        termGateLabel.textAlignment = .right
        termGateLabel.textColor = .black
        view.addSubview(termGateLabel)
        
        termGateLabel = UILabel(frame: LayoutManager.aboveLeft(elementBelow: (tabBarController?.tabBar)!, padding: Constants.MARGINAL_PADDING, width: view.frame.width, height: 15))
        termGateLabel.text = "Terminal/Gate"
        formatLabel(label: termGateLabel)
        termGateLabel.textAlignment = .center
        termGateLabel.textColor = .black
        view.addSubview(termGateLabel)
        
        
    }
    
    func initSwiper() {
        let up = UISwipeGestureRecognizer(target: self, action: #selector(showPane))
        up.direction = .up
        pane.addGestureRecognizer(up)
        
        let down = UISwipeGestureRecognizer(target: self, action: #selector(hidePane))
        down.direction = .down
        pane.addGestureRecognizer(down)
    }
    
    @objc func showPane() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            for view in self.view.subviews {
                if view != self.mapView {
                    view.transform = CGAffineTransform(translationX: 0, y: 0)
                }
            }
        }, completion: nil)
    }
    @objc func hidePane() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            for view in self.view.subviews {
                debugPrint(view.description)
                if view != self.mapView {
                    debugPrint("animating")
                    debugPrint(view.description)
                    view.transform = CGAffineTransform(translationX: 0, y: self.animationDistance)
                }
                debugPrint("--------------------------")
            }
        }, completion: nil)
    }
    
}
