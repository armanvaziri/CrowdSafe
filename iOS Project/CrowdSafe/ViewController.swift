//
//  ViewController.swift
//  CrowdSafe
//
//  Created by Arman Vaziri on 3/11/20.
//  Copyright © 2020 ArmanVaziri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var occupantCountLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

//        readData()
//        print(uniqueOccupantData(file: "occupancy_data"))
//        print("averge height (mm) : ", occupantAverageHeight(file: "occupancy_data"))
    }
    
    func readData(file fileName: String) -> [[String]] {
        
        var result: [[String]] = []
        let dataFileURL: String? = Bundle.main.path(forResource: fileName, ofType: "csv")
        guard (dataFileURL as? String) != nil else { return result}
            
        do {
            let textContent = try String(contentsOfFile: dataFileURL!, encoding: .utf8)
            let rows = textContent.components(separatedBy: "\n")
            
            var counter = 1
            while counter < rows.count - 1 {
                var row = rows[counter].components(separatedBy: ",")
                result.append(row)
                counter += 1
            }
            return result
        } catch  {
            print("error: ", error)
        }
        return result
    }
    
    func uniqueOccupantData(file fileName: String) -> [[String]] {
        let data = readData(file: fileName)
        
        var uniqueOccupantID: [String] = []
        var uniqueOccupantData: [[String]] = []
        
        for row in data {
            if uniqueOccupantID.count == 0 || !(uniqueOccupantID.contains(row[6])) {
                uniqueOccupantID.append(row[6])
                uniqueOccupantData.append(row)
            }
        }
        print("number of unique occupants: ", uniqueOccupantData.count)
        return uniqueOccupantData
    }
    
    func occupantAverageHeight(file fileName: String) -> Int {
        let uniqueOccupants = uniqueOccupantData(file: fileName)
    
        var heightSum = 0
        
        for row in uniqueOccupants {
            heightSum += Int(row[7])!
        }
        return heightSum / uniqueOccupants.count
    }
    
    func currentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return "\(hour):\(minutes)"
    }


}

