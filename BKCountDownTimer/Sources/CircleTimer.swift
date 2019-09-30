//
//  CircleTimer.swift
//  BKCountdownTImer
//
//  Created by moon on 30/09/2019.
//  Copyright © 2019 Bugking. All rights reserved.
//

import UIKit

class CircleTimer: NSObject {
    static let shared = CircleTimer()
    
    public func startCountDown(time:CGFloat, block:@escaping(_ countDown:CGFloat, _ minute:Int, _ second:Int)->(), completion:@escaping()->()) {
        var countDown = time * 60
        
        let initCount = self.convert(time: countDown)
        block(countDown, initCount.share, initCount.rest)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if countDown < 1 {
                timer.invalidate()
                completion()
                return
            }
            countDown -= 1
            let result = self.convert(time: countDown)
            block(countDown, result.share, result.rest)
        }
    }
    
    private func convert(time:CGFloat) -> (share:Int, rest:Int) {
        let shareValue = Int(time/60)
        let resValue = Int(time.truncatingRemainder(dividingBy: 60).rounded())
        
        return (shareValue, resValue)
    }
}
