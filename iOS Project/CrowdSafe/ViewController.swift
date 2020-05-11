//
//  ViewController.swift
//  CrowdSafe
//
//  Created by Arman Vaziri on 3/11/20.
//  Copyright © 2020 ArmanVaziri. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var occupantCountLabel: UILabel!
    @IBOutlet weak var occupantHeightLabel: UILabel!
    @IBOutlet weak var exitPlanButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var topLeft: UIButton!
    @IBOutlet weak var bottomLeft: UIButton!
    @IBOutlet weak var topRight: UIButton!
    @IBOutlet weak var bottomRight: UIButton!
    
    @IBOutlet weak var mostDense: UIButton!
    @IBOutlet weak var mildlyDense: UIButton!
    @IBOutlet weak var leastDense: UIButton!
    
    var topLeftCount = 0
    var bottomLeftCount = 0
    var topRightCount = 0
    var bottomRightCount = 0
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        basicUISetup()
        refreshApp()
        
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(refreshApp), userInfo: nil, repeats: true)
        
    }
    
    @objc func refreshApp() {
        
        print("REFRESHING APP")
        
        topLeftCount = 0
        bottomLeftCount = 0
        topRightCount = 0
        bottomRightCount = 0
        
        let currentData = timeMatchData()
        let uniqueOccData = uniqueOccupantData(data: currentData)
        let averageOccHeight = occupantAverageHeight(data: uniqueOccData)
        
        occupantCountLabel.text = "Occupant count: \(uniqueOccData.count)"
        occupantHeightLabel.text = "Avg. occupant height: \(averageOccHeight)mm"
        
        quadrantDensity(data: uniqueOccData)
        
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        
        print("REFRESH BUTTON PRESSED")
        refreshApp()
        
    }
    
    
    @IBAction func topLeftPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "\(topLeftCount) occupants", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func topRightPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "\(topRightCount) occupants", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func bottomLeftPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "\(bottomLeftCount) occupants", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func bottomRightPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "\(bottomRightCount) occupants", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func basicUISetup()  {
                
        topLeft.layer.cornerRadius = topLeft.frame.height / 2
        topRight.layer.cornerRadius = topRight.frame.height / 2
        bottomLeft.layer.cornerRadius = bottomLeft.frame.height / 2
        bottomRight.layer.cornerRadius = bottomRight.frame.height / 2
        mostDense.layer.cornerRadius = mostDense.frame.height / 2
        mildlyDense.layer.cornerRadius = mildlyDense.frame.height / 2
        leastDense.layer.cornerRadius = leastDense.frame.height / 2
        exitPlanButton.layer.cornerRadius = exitPlanButton.frame.height / 2
        
        self.topLeft.layer.opacity = 0.65
        self.topRight.layer.opacity = 0.65
        self.bottomLeft.layer.opacity = 0.65
        self.bottomRight.layer.opacity = 0.65
        
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
        
        var data: [[String]]
        
        switch today {
        case 1:
            data = readCsvData(file: "day_zero_final")
        case 2:
            data = readCsvData(file: "day_one_final")
        case 3:
            data = readCsvData(file: "day_two_final")
        case 4:
            data = readCsvData(file: "day_three_final")
        case 5:
            data = readCsvData(file: "day_four_final")
        case 6:
            data = readCsvData(file: "day_five_final")
        case 7:
            data = readCsvData(file: "day_six_final")
        default:
            data = readCsvData(file: "day_two_final")
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
            
            if minuteSubstring == String(currentMinute) && hourSubstring == String(currentHour) {
                toReturn.append(data[counter])
            }
//            if minuteSubstring == String(currentMinute) {
//                toReturn.append(data[counter])
//            }
            
            counter += 1
        }
        return toReturn
    }
    
    func uniqueOccupantData(data: [[String]]) -> [[String]] {
        
        var uniqueOccupantID: [String] = []
        var uniqueOccupantData: [[String]] = []
        
        if data.count != 0 {
            for each in data {
                if uniqueOccupantID.count == 0 || !(uniqueOccupantID.contains(each[6])) {
                    uniqueOccupantID.append(each[6])
                    uniqueOccupantData.append(each)
                }
            }
            return uniqueOccupantData
        }
        return uniqueOccupantData
    }
    
    func occupantAverageHeight(data: [[String]]) -> Int {
    
        var heightSum = 0
        
        if data.count == 0 {
            return 0
        }
        
        for row in data {
            heightSum += Int(row[8])!
        }
        return heightSum / data.count
    }
    
    func quadrantDensity(data: [[String]]) {
        
        var upperLeft: Float = 0.0
        var upperRight: Float = 0.0
        var lowerLeft: Float = 0.0
        var lowerRight: Float = 0.0
        
        if data.count == 0 {
            assignQuadEmpty()
        } else {
            for each in data {
                
                let x = Float(each[5])!
                let y = Float(each[6])!

                //topLeft
                if x < 250 && y < 155 {
                    upperLeft += 1
                    self.topLeftCount += 1
                }
                //bottomLeft
                else if x < 250 && y >= 155 {
                    lowerLeft += 1
                    self.bottomLeftCount += 1
                }
                //topRight
                else if x >= 250 && y < 155 {
                    upperRight += 1
                    self.topRightCount += 1
                }
                //bottomRight
                else if x >= 250 && y >= 155 {
                    lowerRight += 1
                    self.bottomRightCount += 1
                }
            }
            
            let total: Float = Float(data.count)

            let quadPercentages = [upperLeft / total, upperRight / total, lowerLeft / total, lowerRight / total]
            assignQuadColors(quadPercentages: quadPercentages)
        }
    }
    
    func assignQuadEmpty() {
        
        self.topLeft.layer.backgroundColor = UIColor.green.cgColor
        self.topRight.layer.backgroundColor = UIColor.green.cgColor
        self.bottomLeft.layer.backgroundColor = UIColor.green.cgColor
        self.bottomRight.layer.backgroundColor = UIColor.green.cgColor
        self.topLeft.layer.opacity = 0.65
        self.topRight.layer.opacity = 0.65
        self.bottomLeft.layer.opacity = 0.65
        self.bottomRight.layer.opacity = 0.65
    }
    
    func assignQuadColors(quadPercentages: [Float]) {
        
        // upperLeft
        if quadPercentages[0] < 0.15 {
            self.topLeft.layer.backgroundColor = UIColor.green.cgColor
        } else if quadPercentages[0] < 0.33 {
            self.topLeft.layer.backgroundColor = UIColor.yellow.cgColor
        } else {
            self.topLeft.layer.backgroundColor = UIColor.red.cgColor
        }
        
        // upperRight
        if quadPercentages[1] < 0.15 {
            self.topRight.layer.backgroundColor = UIColor.green.cgColor
        } else if quadPercentages[1] < 0.33 {
            self.topRight.layer.backgroundColor = UIColor.yellow.cgColor
        } else {
            self.topRight.layer.backgroundColor = UIColor.red.cgColor
        }
        
        // lowerLeft
        if quadPercentages[2] < 0.15 {
            self.bottomLeft.layer.backgroundColor = UIColor.green.cgColor
        } else if quadPercentages[2] < 0.33 {
            self.bottomLeft.layer.backgroundColor = UIColor.yellow.cgColor
        } else {
            self.bottomLeft.layer.backgroundColor = UIColor.red.cgColor
        }
        
        // lowerRight
        if quadPercentages[3] < 0.15 {
            self.bottomRight.layer.backgroundColor = UIColor.green.cgColor
        } else if quadPercentages[3] < 0.33 {
            self.bottomRight.layer.backgroundColor = UIColor.yellow.cgColor
        } else {
            self.bottomRight.layer.backgroundColor = UIColor.red.cgColor
        }
        
        self.topLeft.layer.opacity = 0.65
        self.topRight.layer.opacity = 0.65
        self.bottomLeft.layer.opacity = 0.65
        self.bottomRight.layer.opacity = 0.65
        
    }
    
}


