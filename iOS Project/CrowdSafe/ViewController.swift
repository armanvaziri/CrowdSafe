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
    
    var LiveData: OccupantInfo = OccupantInfo()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

