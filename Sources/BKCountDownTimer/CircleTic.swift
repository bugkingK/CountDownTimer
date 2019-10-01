//
//  CircleTic.swift
//  BKCountdownTImer
//
//  Created by moon on 30/09/2019.
//  Copyright © 2019 Bugking. All rights reserved.
//

import UIKit

@IBDesignable
public class CircleTic: CircleBase {

    //MARK:- 🔶 @IBInspectable
    /// 시계 외각에 촘촘히 그려져 있는 선 중 가장 두꺼운 선의 색을 정합니다.
    @IBInspectable public var boldBezelColor:UIColor = .black
    /// 시계 외각에 촘촘히 그려져 있는 선 중 가장 얇은 선의 색을 정합니다.
    @IBInspectable public var thinBezelColor:UIColor = .black
    ///
    @IBInspectable public var expandTic:Bool = false
    
    //MARK:- 🔶 @public

    //MARK:- 🔶 @override
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        var frame: CGRect = rect
        if expandTic {
            frame.origin.x -= rect.width / 7
            frame.origin.y -= rect.height / 7
            frame.size.width += rect.width / 3.5
            frame.size.height += rect.height / 3.5
        }
        let ticView = CircleWithTic(frame: frame)
        ticView.backgroundColor = .clear
        self.addSubview(ticView)
    }
    
}

fileprivate class CircleWithTic: UIView {
    
    //MARK:- 🔶 @IBInspectable
    /// 시계 외각에 촘촘히 그려져 있는 선 중 가장 두꺼운 선의 색을 정합니다.
    var boldBezelColor:UIColor = .black
    /// 시계 외각에 촘촘히 그려져 있는 선 중 가장 얇은 선의 색을 정합니다.
    var thinBezelColor:UIColor = .black
    /// 반지름
    var radius:CGFloat = 5

    //MARK:- 🔶 @override
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let centerPoint = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        radius = min(centerPoint.x, centerPoint.y)
        self.drawBoldBezel(rect)
        self.drawThinBezel(rect)
    }
    
    //MARK:- 🔶 @private Method
    private func drawBoldBezel(_ rect:CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        let boldBezelWidth = self.radius / 30
        let boldBezelSize:CGFloat = boldBezelWidth * 3
        let boldBezelRect = CGRect(x: -boldBezelWidth/2, y: 0, width: boldBezelWidth, height: boldBezelSize)
        let boldBezelPath = UIBezierPath(rect: boldBezelRect)
        let angleDifference: CGFloat = .pi / 6
        
        context.saveGState()
        self.boldBezelColor.setFill()
        context.translateBy(x: rect.width / 2, y: rect.height / 2)
        
        for i in 1...12 {
            context.saveGState()
            let angle = angleDifference * CGFloat(i) + .pi
            context.rotate(by: angle)
            context.translateBy(x: 0, y: rect.height / 2.1 - boldBezelSize)
            boldBezelPath.fill()
            context.restoreGState()
        }
        context.restoreGState()
    }
    
    private func drawThinBezel(_ rect:CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        let thinBezelWidth = self.radius / 70
        let thinBezelSize:CGFloat = thinBezelWidth * 7
        let thinBezelRect:CGRect = CGRect(x: -thinBezelWidth/2, y: 0, width: thinBezelWidth, height: thinBezelSize)
        let thinBezelPath = UIBezierPath(rect: thinBezelRect)
        let angleDifference:CGFloat = .pi / 30
        
        context.saveGState()
        self.thinBezelColor.setFill()
        context.translateBy(x: rect.width / 2, y: rect.height / 2)
        
        for i in 1...60 {
            if i % 5 == 0 {
                continue
            }
            context.saveGState()
            let angle = angleDifference * CGFloat(i) + .pi
            context.rotate(by: angle)
            context.translateBy(x: 0, y: rect.height / 2.1 - thinBezelSize)
            thinBezelPath.fill()
            context.restoreGState()
        }
        context.restoreGState()
    }


}
