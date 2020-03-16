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
        // Do any additional setup after loading the view.
        readData()
    }
    
    func readData() -> [[String]] {
        
        var result: [[String]] = []
        
        let dataFileURL: String? = Bundle.main.path(forResource: "occupancy_data", ofType: "csv")
        
        guard (dataFileURL as? String) != nil else { return result}
            
        do {
            
            let fileUrls = try FileManager.default.contents(atPath: dataFileURL!)
            
            let textContent = try String(contentsOfFile: dataFileURL!, encoding: .utf8)
            
            let rows = textContent.components(separatedBy: "\n")
            print("count of rows: ", rows.count)
            
            var counter = 1
            
            while counter < rows.count - 1 {
                var row = rows[counter].components(separatedBy: ",")
                print("row: ", row)
                result.append(row)
                counter += 1
            }
            return result
        } catch  {
            print("error: ", error)
        }
        return result
    }


}

