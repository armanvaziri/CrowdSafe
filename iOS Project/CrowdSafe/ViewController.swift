//
//  ViewController.swift
//  CrowdSafe
//
//  Created by Arman Vaziri on 3/11/20.
//  Copyright © 2020 ArmanVaziri. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var occupantCountLabel: UILabel!
    @IBOutlet weak var occupantHeightLabel: UILabel!
    
    @IBOutlet weak var topLeft: UIButton!
    @IBOutlet weak var bottomLeft: UIButton!
    @IBOutlet weak var topRight: UIButton!
    @IBOutlet weak var bottomRight: UIButton!
    
    
    @IBOutlet weak var mostDense: UIButton!
    @IBOutlet weak var mildlyDense: UIButton!
    @IBOutlet weak var leastDense: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentData = timeMatchData()
        let uniqueOccData = uniqueOccupantData(data: currentData)
        let averageOccHeight = occupantAverageHeight(data: uniqueOccData)
        
        timeLabel.text = currentTimeString()
        occupantCountLabel.text = "Occupant count: \(uniqueOccData.count)"
        occupantHeightLabel.text = "Avg. occupant height: \(averageOccHeight)mm"

//        basicUISetup()
        
    }
    
    func basicUISetup()  {
        
        navigationController?.navigationBar.barTintColor = UIColor.systemBlue
        
        topLeft.layer.cornerRadius = topLeft.frame.height / 2
        topRight.layer.cornerRadius = topRight.frame.height / 2
        bottomLeft.layer.cornerRadius = bottomLeft.frame.height / 2
        bottomRight.layer.cornerRadius = bottomRight.frame.height / 2
        mostDense.layer.cornerRadius = mostDense.frame.height / 2
        mildlyDense.layer.cornerRadius = mildlyDense.frame.height / 2
        leastDense.layer.cornerRadius = leastDense.frame.height / 2
        
        topLeft.layer.backgroundColor = UIColor.red.cgColor
        topRight.layer.backgroundColor = UIColor.yellow.cgColor
        bottomLeft.layer.backgroundColor = UIColor.green.cgColor
        bottomRight.layer.backgroundColor = UIColor.green.cgColor
        
    }
    
    /* Order of operations:
        1. read csv file according to today's day of the week
        2. iterate through and find rows that match the hour and minute
        3. iterate through and obtain one row per unique occupant
        4. count the number of unique occupants and average their heights
        5. use x-y coordinates of unique occupant data to determine density in room
     */
    
    func updateUI() {
        
        

    }
    
    func readCsvData(file fileName: String) -> [[String]] {
        
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
    
    func timeMatchData() -> [[String]] {
        
        var toReturn: [[String]] = []
        
        let date = Date()
        let calendar = Calendar(identifier: .iso8601)
        let today = calendar.component(.weekday, from: date)
        
        var data: [[String]] = []
        
        switch today {
        case 0:
            data = readCsvData(file: "day_zero_final")
        case 1:
            data = readCsvData(file: "day_one_final")
        case 2:
            data = readCsvData(file: "day_two_final")
        case 3:
            data = readCsvData(file: "day_three_final")
        case 4:
            data = readCsvData(file: "day_four_final")
        case 5:
            data = readCsvData(file: "day_five_final")
        case 6:
            data = readCsvData(file: "day_six_final")
        default:
            break
        }
        
        var counter = 1
        while counter < data.count - 1 {
            
            let time = data[counter][1]
            let lowerBound = String.Index.init(encodedOffset: 0)
            let upperBound = String.Index.init(encodedOffset: 5)
            let hourUpperBound = String.Index.init(encodedOffset: 2)
            let minuteLowerBound = String.Index.init(encodedOffset: 3)

            let timeSubstring: Substring = time[lowerBound..<upperBound]
            let hourSubstring: Substring = time[lowerBound..<hourUpperBound]
            let minuteSubstring: Substring = time[minuteLowerBound..<upperBound]
            
            // check if data's hour and minute are equivalent to current
            let currentHour = calendar.component(.hour, from: date)
            let currentMinute = calendar.component(.minute, from: date)
            
            if minuteSubstring == String(currentMinute) {
                toReturn.append(data[counter])
                print("TIME ADDED: \(timeSubstring)")
            }
            
            counter += 1
        }
        
        return toReturn
    }
    
    func uniqueOccupantData(data: [[String]]) -> [[String]] {
        
        var uniqueOccupantID: [String] = []
        var uniqueOccupantData: [[String]] = []
        
        for each in data {
            if uniqueOccupantID.count == 0 || !(uniqueOccupantID.contains(each[6])) {
                uniqueOccupantID.append(each[6])
                uniqueOccupantData.append(each)
            }
        }
        return uniqueOccupantData
    }
    
    func occupantAverageHeight(data: [[String]]) -> Int {
    
        var heightSum = 0
        
        for row in data {
            heightSum += Int(row[7])!
        }
        return heightSum / data.count
    }
    
    func currentTimeString() -> String {
        let date = Date()
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        if hour < 12 {
            return "\(hour):\(minutes) am"
        } else {
            hour = hour - 12
            return "\(hour):\(minutes) pm"
        }
    
    }

}


