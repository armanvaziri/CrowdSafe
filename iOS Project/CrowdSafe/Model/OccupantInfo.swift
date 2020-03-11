//
//  OccupantInfo.swift
//  CrowdSafe
//
//  Created by Arman Vaziri on 3/11/20.
//  Copyright © 2020 ArmanVaziri. All rights reserved.
//

import Foundation

class OccupantInfo {
    
    var Info: [Occupant] = [
        Occupant(location: "Generic", time: "08:00:00", day: 0, height: 1000, x_coor: 10, y_coor: 10)
    ]
    
}

struct Occupant {
    var location: String
    var time: String
    var day: Int
    var height: Int
    var x_coor: Int
    var y_coor: Int
}
