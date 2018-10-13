//
//  Flight.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/9/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import SwiftyJSON
class Flight: Comparable {
    static func < (lhs: Flight, rhs: Flight) -> Bool {
        return lhs.departScheduled.timeIntervalSince1970 < rhs.departScheduled.timeIntervalSince1970
    }
    
    static func == (lhs: Flight, rhs: Flight) -> Bool {
        return (lhs.id == rhs.id) && (lhs.departScheduled.timeIntervalSince1970 == rhs.departScheduled.timeIntervalSince1970)
    }
    
    // Times
    var departScheduled: Date!
    var departActual: Date?
    var arriveScheduled: Date!
    var arriveActual: Date?
        
    // Plane info
    var id: String!
    var dateString: String!
    var planeType: Plane!
    
    // Status & Gates
    var status: String!
    var departGate: String!
    var departTerm: String!
    var arriveGate: String!
    var arriveTerm: String!
    
    var departingAirport: Airport!
    var arrivingAirport: Airport!
    
    init(json: JSON, id: String, date: String) {
        self.id = id
        self.dateString = date
        departScheduled = Utils.convertToDate(timestring: json["Departure"]["ScheduledTimeLocal"]["DateTime"].stringValue)!
        departActual = Utils.convertToDate(timestring: json["Departure"]["ActualTimeLocal"]["DateTime"].stringValue)
        arriveScheduled = Utils.convertToDate(timestring: json["Arrival"]["ScheduledTimeLocal"]["DateTime"].stringValue)!
        arriveActual = Utils.convertToDate(timestring: json["Arrival"]["ActualTimeLocal"]["DateTime"].stringValue)

        
        let planeTypeString = Utils.cleanJSONRead(json["Equipment"]["AircraftCode"].stringValue, other: "Not Available")
        planeType = Plane(name: planeTypeString)
        
        
        status = json["FlightStatus"]["Definition"].stringValue
        status = Utils.cleanJSONRead(status ?? "", other: "Not Available")
        
        departGate = json["Departure"]["Terminal"]["Gate"].stringValue
        departGate = Utils.cleanJSONRead(departGate ?? "", other: "--")

        departTerm = json["Departure"]["Terminal"]["Name"].stringValue
        departTerm = Utils.cleanJSONRead(departTerm ?? "", other: "--")

        arriveGate = json["Arrival"]["Terminal"]["Gate"].stringValue
        arriveGate = Utils.cleanJSONRead(arriveGate ?? "", other: "--")

        arriveTerm = json["Arrival"]["Terminal"]["Name"].stringValue
        arriveTerm = Utils.cleanJSONRead(arriveTerm ?? "", other: "--")

        departingAirport = Airport(airportCode: json["Departure"]["AirportCode"].stringValue)
        arrivingAirport = Airport(airportCode: json["Arrival"]["AirportCode"].stringValue)
        
    }
    
    
    
}
