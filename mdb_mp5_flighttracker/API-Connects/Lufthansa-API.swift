//
//  Lufthansa-API.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/9/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class LufthansaAPI {
    
    static var authToken: String?
    static var allAirportOffset = 0
    static var maxPulls = 100
    static var allowMorePulls = true
    
    static func sendGetRequest(endpoint: String, paths: [String], callback: @escaping ((JSON) -> ())) {
        if authToken == nil {
            guard let storedToken = LocalData.getLocalData(forKey: .lufthansaAuth) else {
                getAuthToken { (_) in
                    sendGetRequest(endpoint: endpoint, paths: paths, callback: callback)
                }
                return
            }
            authToken = storedToken
        }
        
        let parameters: HTTPHeaders = ["Authorization": "Bearer \(authToken!)", "Accept": "application/json"]
        
        debugPrint("Sending Get Request: \(endpoint)")
        
        Alamofire.request(endpoint, headers: parameters).responseJSON { response in
            //Makes sure that response is valid
            guard response.result.isSuccess else {
                print(response.result.error.debugDescription)
                return
            }
            //Creates JSON object
            var json = JSON(response.result.value!)
            debugPrint("Received HTTP Response")
            debugPrint(json)
            
            if json["Error"].stringValue != "" {
                debugPrint("Reestablishing Auth Token")
                getAuthToken { (_) in
                    sendGetRequest(endpoint: endpoint, paths: paths, callback: callback)
                }
                return
            }
            
            if endpoint.contains(Constants.ALL_AIRPORTS) {
                maxPulls = json["AirportResource"]["Meta"]["TotalCount"].intValue
                debugPrint("Set Max pulls")
                debugPrint(maxPulls)
            }

            for path in paths {
                json = json[path]
            }
            
            callback(json)
        }
    }
    
    static func getAuthToken(callback: @escaping (String?) -> ()) {
        var parameters: HTTPHeaders = ["Accept": "application/json"]
        parameters["client_id"] = Constants.LUFTHANSA_CLIENTID
        parameters["client_secret"] = Constants.LUFTHANSA_CLIENTSECRET
        parameters["grant_type"] = "client_credentials"
        
        Alamofire.request(Constants.AUTH_ENDPOINT, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: ["Content-Type": "application/x-www-form-urlencoded"]).responseJSON { response in
            //Makes sure that response is valid
            let json = JSON(response.result.value!)
            debugPrint(json)
            let authToken = json["access_token"].stringValue
            debugPrint("Acuired new Auth Token")
            debugPrint(authToken)
            if authToken != "" {
                self.authToken = authToken
                LocalData.putLocalData(forKey: .lufthansaAuth, data: authToken)
                callback(authToken)
            } else {
                callback(nil)
            }
        }
        
    }
    
    static func getAirportDetails(id: String, callback: @escaping (JSON) -> ()) {
        // check if auth in memory
        let getURL = [Constants.AIRPORT_DEETS, id].joined(separator: "/")
        let targetPaths = ["AirportResource", "Airports", "Airport"]
        sendGetRequest(endpoint: getURL, paths: targetPaths, callback: callback)
    }
    
    // Endpoint Builders
    static func getFlightDetails(id: String, date: String, callback: @escaping (JSON) -> ()) {
        let getURL = [Constants.FLIGHT_STATUS, id, date].joined(separator: "/")
        let targetPaths = ["FlightStatusResource", "Flights", "Flight"]
        sendGetRequest(endpoint: getURL, paths: targetPaths, callback: callback)
    }
    
    static func getFlightDetails(url: String, callback: @escaping (JSON) -> ()) {
        let getURL = url
        let targetPaths = ["FlightStatusResource", "Flights", "Flight"]
        sendGetRequest(endpoint: getURL, paths: targetPaths, callback: callback)
    }
    
    static func getAircraftDetails(code: String, callback: @escaping(JSON) -> ()) {
        let getURL = [Constants.AIRCRAFT_INFO, code].joined(separator: "/")
        let targetPaths = ["AircraftResource", "AircraftSummaries"]
        sendGetRequest(endpoint: getURL, paths: targetPaths, callback: callback)
    }
    
    static func getAllAirports(callback: @escaping (JSON) -> ()) {
        if allAirportOffset > maxPulls {
            callback(JSON.null)
            return
        }
        let getURL = Constants.ALL_AIRPORTS + "&offset=\(allAirportOffset)"
        allAirportOffset += 100
        let targetPaths = ["AirportResource", "Airports", "Airport"]
        sendGetRequest(endpoint: getURL, paths: targetPaths, callback: callback)
    }
    
    static func getFlightsForAirport(endpoint: String, airportLocation: CLLocation, airportCode: String, callback: @escaping (JSON) -> ()) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm"
        
        let reasonableHourOffset:Double = 60 * 60 * 12 * 0
        var targetDate = dateFormatter.string(from: Date.init(timeIntervalSinceNow: reasonableHourOffset))
        //        targetDate = "2018-10-19T10:00"
        
        let getURL = [endpoint, airportCode, targetDate].joined(separator: "/")
        let targetPaths = ["FlightStatusResource", "Flights", "Flight"]
        
//        let timezone = airportLocation.timezone
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(airportLocation) { (placemarks, err) in
            guard let place = placemarks else {
                sendGetRequest(endpoint: getURL, paths: targetPaths, callback: callback)
                return
            }
            guard let tz = place[0].timeZone else {
                sendGetRequest(endpoint: getURL, paths: targetPaths, callback: callback)
                return
            }
            
            dateFormatter.timeZone = tz
            targetDate = dateFormatter.string(from: Date.init(timeIntervalSinceNow: reasonableHourOffset))
            let getURL = [endpoint, airportCode, targetDate].joined(separator: "/")
            sendGetRequest(endpoint: getURL, paths: targetPaths, callback: callback)

        }
        
        
    }
    
    static func getArrivalsFromAirport(airportCode: String, airportLocation: CLLocation, callback: @escaping (JSON) -> ()) {
        getFlightsForAirport(endpoint: Constants.ARRIVALS, airportLocation: airportLocation, airportCode: airportCode, callback: callback)
        
    }
    
    static func getDeparturesFromAirport(airportCode: String, airportLocation: CLLocation, callback: @escaping (JSON) -> ()) {
        getFlightsForAirport(endpoint: Constants.DEPARTURES, airportLocation: airportLocation, airportCode: airportCode, callback: callback)
    }
    
}
