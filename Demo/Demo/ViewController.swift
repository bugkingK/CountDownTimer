//
//  ViewController.swift
//  Demo
//
//  Created by moon on 01/10/2019.
//  Copyright © 2019 Bugking. All rights reserved.
//

import UIKit
import BKCountDownTimer

class ViewController: UIViewController {

    @IBOutlet weak var vwCircle:CircleCount!
    @IBOutlet weak var vwCircleTic:CircleTic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        vwCircle.startTimer(block: { (count, minute, second) in
            print("\(minute) : \(second)")
        }) {
            print("complete")
        }
        
        vwCircleTic.touchBeginEvent = {
            print("touch")
        }
        
        vwCircleTic.touchEndedEvent = {
            print("end")
        }
        
        vwCircleTic.touchMovedEvent = {
            print("move")
        }
    }
}

