//
//  ViewController.swift
//  BKCountDownTimer
//
//  Created by moon on 30/09/2019.
//  Copyright © 2019 Bugking. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var vwCircle:CircleCount!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        vwCircle.startTimer(block: { (count, minute, second) in
            print("\(minute) : \(second)")
        }) {
            print("complete")
        }
        
        vwCircle.touchBeginEvent = {
            print("touch")
        }
        
        vwCircle.touchEndedEvent = {
            print("end")
        }
        
        vwCircle.touchMovedEvent = {
            print("move")
        }
    }
}

