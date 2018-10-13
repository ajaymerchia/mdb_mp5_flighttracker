//
//  FlightCell.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/12/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import UIKit

class FlightCell: UITableViewCell {

    var flight: Flight!
    var flightNumber: UILabel!
    
    var flightOrigin: UILabel!
    var flightDestin: UILabel!
    
    var flightStatus: UILabel!
    var flightTiming: UILabel!
    
    let timingPrefix = ["Departs at: ", "Arrives at: ", "Scheduled: "]
    
    var rowHeight:CGFloat = 80
    
    override func awakeFromNib() {
        self.backgroundColor = .white
        
        let label_height:CGFloat = 30
        flightNumber = UILabel(frame: CGRect(x: Constants.PADDING, y: 10, width: 100, height: label_height))
        flightNumber.font = Constants.TEXT_FONT
        flightNumber.textColor = .flatGrayDark
        flightNumber.adjustsFontSizeToFitWidth = true
        contentView.addSubview(flightNumber)

        
        flightOrigin = UILabel(frame: LayoutManager.belowLeft(elementAbove: flightNumber, padding: 0, width: 60, height: label_height))
        flightOrigin.font = Constants.SUBTITLE_FONT
        contentView.addSubview(flightOrigin)

        let arrowView = UIImageView(frame: CGRect(x: flightOrigin.frame.maxX + Constants.MARGINAL_PADDING, y: flightOrigin.frame.midY - Constants.PADDING/2, width: Constants.PADDING, height: Constants.PADDING))
        arrowView.image = UIImage(named: "arrow-black")
        arrowView.contentMode = .scaleAspectFit
        contentView.addSubview(arrowView)
        
        flightDestin = UILabel(frame: CGRect(x: arrowView.frame.maxX + Constants.MARGINAL_PADDING, y: flightOrigin.frame.minY, width: flightOrigin.frame.width, height: flightOrigin.frame.height))
        flightDestin.font = Constants.SUBTITLE_FONT
        contentView.addSubview(flightDestin)
        
        
    }
    
    func theRightAligned(width: CGFloat) {
        let statusWidth = width/2.5
        flightStatus = UILabel(frame: CGRect(x: width - (Constants.PADDING + statusWidth), y: flightOrigin.frame.minY, width: statusWidth, height: flightOrigin.frame.height))
        flightStatus.font = Constants.TEXT_FONT
        flightStatus.textAlignment = .right
        flightStatus.contentMode = .bottom
        contentView.addSubview(flightStatus)
        
        flightTiming = UILabel(frame: LayoutManager.aboveCentered(elementBelow: flightStatus, padding: 0, width: flightStatus.frame.width, height: flightStatus.frame.height))
        flightTiming.font = Constants.TEXT_FONT
        flightTiming.textAlignment = .right
        flightTiming.contentMode = .bottom
        flightTiming.textColor = .flatGrayDark

        contentView.addSubview(flightTiming)
    }
    
    func initializeCellFrom(flight: Flight, state: Int, expectedWidth: CGFloat) {
        flightNumber.text = flight.id
        flightOrigin.text = flight.departingAirport.airportCode
        flightDestin.text = flight.arrivingAirport.airportCode
        theRightAligned(width: expectedWidth)
        flightStatus.text = flight.status
        
        var selectedDate = Date.init()
        if state == 0 {
            selectedDate = flight.departActual ?? flight.departScheduled
        } else if state == 1 {
            selectedDate = flight.arriveActual ?? flight.arriveScheduled
        } else {
            selectedDate = flight.departScheduled
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        flightTiming.text = timingPrefix[state] + dateFormatter.string(from: selectedDate)
        
    }
    

}
