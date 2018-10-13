//
//  LayoutManager.swift
//  mdb_mp5_flighttracker
//
//  Created by Ajay Raj Merchia on 10/10/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import UIKit

class LayoutManager {
    static func belowCentered(elementAbove: UIView, padding: CGFloat, width:CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementAbove.frame.midX - width/2, y: elementAbove.frame.maxY + padding, width: width, height: height)
    }
    static func belowLeft(elementAbove: UIView, padding: CGFloat, width:CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementAbove.frame.minX, y: elementAbove.frame.maxY + padding, width: width, height: height)
    }
    
    
    static func aboveCentered(elementBelow: UIView, padding: CGFloat, width:CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementBelow.frame.midX - width/2, y: elementBelow.frame.minY - (padding+height), width: width, height: height)
    }
    
    static func aboveLeft(elementBelow: UIView, padding: CGFloat, width:CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementBelow.frame.minX, y: elementBelow.frame.minY - (padding+height), width: width, height: height)
    }
    
    
    
    
}
