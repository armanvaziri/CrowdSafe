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
    @IBOutlet var occupantCountLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        
    }
    
    func updateUI() {
        let occupantCount: Int = uniqueOccupantData(file: "occupancy_data").count
        let averageHeight = occupantAverageHeight(file: "occupancy_data")
        occupantCountLabel.text = "occupant count: \(occupantCount)"
        locationLabel.text = "average height of occupants: \(averageHeight) mm"
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
    
    func timeParsedData(time: String) -> Date {
        var toReturn: [[String]] = []
        let currTime = currentTime()

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "HH:mm:ssZ"
        let date = dateFormatter.date(from: time)
    
        return date!
    }
    
    func currentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return "\(hour):\(minutes)"
    }


}

