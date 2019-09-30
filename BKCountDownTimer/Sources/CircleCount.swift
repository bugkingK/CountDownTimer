//
//  CircleCount.swift
//  BKCountdownTImer
//
//  Created by moon on 30/09/2019.
//  Copyright © 2019 Bugking. All rights reserved.
//

import UIKit

@IBDesignable
public class CircleCount: CircleTic {

    //MARK:- 🔶 @private
    /// 가운데 위치한 타이머
    private var lbMiddleTimer:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.layer.backgroundColor = UIColor.white.cgColor
        return lb
    }()
    
    //MARK:- 🔶 @override
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        self.drawMiddleTimer()
    }
    
    public override func startTimer(block: @escaping (CGFloat, Int, Int) -> (), completion: @escaping () -> ()) {
        super.startTimer(block: { [weak self] (count, minute, second) in
            guard let `self` = self else { return }
            var v_minute:String = "\(minute)"
            var v_second:String = "\(second)"
            if minute < 10 {
                v_minute = "0\(minute)"
            }
            
            if second < 10 {
                v_second = "0\(second)"
            }
            let strCountDown:String = "\(v_minute):\(v_second)"
            self.lbMiddleTimer.text = strCountDown
        }, completion: completion)
    }
    
    private func drawMiddleTimer() {
        let timerCenter:CGPoint = CGPoint(x: centerPoint.x - radius/2, y: centerPoint.y - radius/2)
        self.lbMiddleTimer.frame = CGRect(x: timerCenter.x, y: timerCenter.y, width: radius, height: radius)
        self.lbMiddleTimer.layer.cornerRadius = radius/2
        self.lbMiddleTimer.font = UIFont.boldSystemFont(ofSize: radius/4)
        let nMinute = Int(minuteValue)
        self.lbMiddleTimer.text = nMinute < 10 ? "0\(nMinute):00" : "\(nMinute):00"
        self.addSubview(self.lbMiddleTimer)
    }
    
    public override func touchesEnded(_ tap: CGPoint, _ endAngle: CGFloat) {
        var nMinute:Int = isClockwise ? Int(((360 - endAngle)/6).rounded()) : Int((endAngle/6).rounded())
        if nMinute <= 0 {
            // Circle을 빈공간으로 그립니다.
            nMinute = 1
        } else if nMinute > 59 {
            // 60으로 고정
            nMinute = 60
        }
        
        self.minuteValue = CGFloat(nMinute)
        self.lbMiddleTimer.text = nMinute < 10 ? "0\(nMinute):00" : "\(nMinute):00"
    }
}

