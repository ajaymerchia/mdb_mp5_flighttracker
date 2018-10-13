//
//  Request-initUI.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/9/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

extension RequestFlightViewController {
    func calculateConstants() {
        INNER_BOX_WIDTH = view.frame.width - 2*INTERNAL_PADDING
        OUTER_BOX_WIDTH = view.frame.width - 2*Constants.PADDING
    }
    
    func setUpManagers() {
        alerts = AlertManager(view: self, stateRestoration: {
            self.hud?.dismiss()
            self.flightRequestTrigger.isUserInteractionEnabled = true
        })
    }
    
    func initUI() {
        view.backgroundColor = Constants.CORPORATE_COLOR
        Utils.addBackgroundImage(givenView: self.view, imgName: "lufthansa", opacity: 0.5)
        addHeader()
        initRequestEntryElements()
        addDefaultData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        hud?.dismiss()
        flightRequestTrigger.isUserInteractionEnabled = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        hud?.dismiss()
        flightRequestTrigger.isUserInteractionEnabled = true
        
    }
    
    
    func addHeader() {
        // Add Header Image
        headerImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width/4, height: view.frame.width/4))
        headerImage.center = CGPoint(x: view.frame.width/2, y: Constants.PADDING*2 + headerImage.frame.height/2)
        headerImage.image = UIImage(named: "lufthansa-logo-light")
        headerImage.contentMode = .scaleAspectFill
        headerImage.clipsToBounds = true
        view.addSubview(headerImage)
        
        // Add Header Text
        headerText = UILabel(frame: LayoutManager.belowCentered(elementAbove: headerImage, padding: Constants.PADDING, width: view.frame.width, height: 50))
        headerText.text = "Lufthansa"
        headerText.textAlignment = .center
        headerText.font = Constants.HEADER_FONT
        headerText.textColor = .white
        view.addSubview(headerText)
        
        subtitle = UILabel(frame: LayoutManager.belowCentered(elementAbove: headerText, padding: 0, width: view.frame.width, height: 30))
        subtitle.text = "Flight Tracker"
        subtitle.textAlignment = .center
        subtitle.font = Constants.SUBTITLE_FONT
        subtitle.textColor = .white
        view.addSubview(subtitle)
    }
    
    func initRequestEntryElements() {
        
        flightNumberEntry = UITextField(frame: CGRect(x: INTERNAL_PADDING, y: view.frame.height * 1.8/3, width: INNER_BOX_WIDTH, height: 50))
        flightNumberEntry.attributedPlaceholder = NSAttributedString(string: "Flight Number", attributes: [NSAttributedString.Key.foregroundColor: rgba(200,200,200,1)])
        flightNumberEntry.textColor = .white
        flightNumberEntry.font = Constants.SUBTITLE_FONT
        flightNumberEntry.textAlignment = .center
        view.addSubview(flightNumberEntry)
        
        flightDatePicker = UIDatePicker(frame: LayoutManager.belowCentered(elementAbove: flightNumberEntry, padding: 0, width: flightNumberEntry.frame.width + INTERNAL_PADDING, height: 50))
        flightDatePicker.datePickerMode = .date
        flightDatePicker.tintColor = .white
        flightDatePicker.setValue(UIColor.white, forKey: "textColor")
        view.addSubview(flightDatePicker)
        
        flightRequestTrigger = UIButton(frame: LayoutManager.belowCentered(elementAbove: flightDatePicker, padding: Constants.PADDING, width: INNER_BOX_WIDTH, height: 60))
        flightRequestTrigger.titleLabel?.font = Constants.SUBTITLE_FONT
        flightRequestTrigger.setTitle("Get Flights", for: .normal)
        flightRequestTrigger.setTitleColor(Constants.CORPORATE_COLOR, for: .normal)
        flightRequestTrigger.setBackgroundColor(color: .white, forState: .normal)
        flightRequestTrigger.setBackgroundColor(color: UIColor.flatWhite, forState: .highlighted)
        flightRequestTrigger.addTarget(self, action: #selector(searchFlights), for: .touchUpInside)
        flightRequestTrigger.layer.cornerRadius = 10
        flightRequestTrigger.clipsToBounds = true
        view.addSubview(flightRequestTrigger)
        
        
    }
    
    func addDefaultData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
        let defaultDate = dateFormatter.date(from: "2018-10-10")
        
        flightDatePicker.setDate(defaultDate!, animated: true)
        flightNumberEntry.text = "LH004"
    }
}
