//
//  CircleBase.swift
//  BKCountdownTImer
//
//  Created by moon on 30/09/2019.
//  Copyright © 2019 Bugking. All rights reserved.
//

import UIKit

@IBDesignable
public class CircleBase: UIView {
    //MARK:- 🔶 @IBInspectable
    /// true는 시계방향, false 반시계방향
    @IBInspectable public var isClockwise: Bool = true
    /// Circle의 색을 지정합니다.
    @IBInspectable public var fillColor: UIColor? = UIColor.red
    /// 그린 원이 소수점으로 떨어지지 않도록 자동으로 계산합니다.
    @IBInspectable public var isAutoControl: Bool = false
    /// Circle의 각도를 지정합니다.
    @IBInspectable public var minuteValue:CGFloat = 45 {
        didSet {
            self.drawCircle(time: minuteValue)
        }
    }
    
    //MARK:- 🔶 @private
    /// 계산시 처음 0도 기준이 3시방향 이므로 12시방향 기준이 되려면 -90도 조정
    fileprivate var m_start_angle:CGFloat = -90
    /// 이 값이 변경됨에 따라 원의 부채꼴크기가 결정됨.
    fileprivate var m_end_angle:CGFloat = 180
    /// 원의 부채꼴을 채우는 레이어
    fileprivate var m_fill_layer:CAShapeLayer = CAShapeLayer()
    /// 시계방향일 때 원을 모두 채우는 값
    fileprivate let MAX_ANGLE_CW:CGFloat = 0.001
    /// 반 시계방향일 때 원을 모두 채우는 값
    fileprivate let MAX_ANGLE:CGFloat = 359.999
    
    //MARK:- 🔶 @internal
    /// 원의 반지름
    internal var radius:CGFloat = 0
    /// 가운데 좌표
    internal var centerPoint:CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            radius = min(centerPoint.x, centerPoint.y)
        }
    }
    
    //MARK:- 🔶 @public
    public var touchBeginEvent:(()->())? = nil
    public var touchMovedEvent:(()->())? = nil
    public var touchEndedEvent:(()->())? = nil
    
    //MARK:- 🔶 @override
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        self.centerPoint = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        self.m_fill_layer.frame = self.bounds
        self.layer.addSublayer(self.m_fill_layer)
        self.drawCircle(time: minuteValue)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.centerPoint = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        self.m_fill_layer.frame = self.bounds
        self.drawCircle(time: minuteValue)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchBeginEvent?()
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        touchMovedEvent?()
        guard let touch = self.getLastValue(touches) else {
            return
        }
        let tapPoint = touch.location(in: self)
        let angle = self.angleToPoint(tapPoint)
        
        m_end_angle = CGFloat(angle).rounded();
        self.drawCircle(angle:m_end_angle)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchEndedEvent?()
        var finalAngle = m_end_angle
        if isAutoControl {
            let rest = finalAngle.truncatingRemainder(dividingBy: 6)
            if rest > 2.5 {
                finalAngle = (finalAngle+(6-rest)).rounded()
            } else {
                finalAngle = (finalAngle-rest).rounded()
            }
        }
        
        let time = self.convertTime(angle: finalAngle)
        self.drawCircle(time: time)
        
        guard let touch = self.getLastValue(touches) else {
            return
        }
        let tapPoint = touch.location(in: self)
        self.touchesEnded(tapPoint, m_end_angle)
    }
    
    public func touchesEnded(_ tap: CGPoint, _ endAngle: CGFloat) { }
    
    //MARK:- 🔶 @public Method
    /// time을 입력한 값으로 Circle을 그립니다. 0보다 작으면 빈 공간을 그리고 60보다 크면 화면을 가득 채웁니다.
    public func drawCircle(time:CGFloat) {
        if time <= 0 {
            // Circle을 빈공간으로 그립니다.
            m_end_angle = isClockwise ? 360.0 : 0.0
        } else if time > 59 {
            // 60으로 고정
            m_end_angle = isClockwise ? MAX_ANGLE_CW : MAX_ANGLE
        } else {
            // 0 < time <= 59
            m_end_angle = isClockwise ? (360.0-(time*6.0)) : (time*6.0)
        }
        
        self.drawCircle(angle:m_end_angle)
    }
    
    //MARK:- 🔶 @public Method
    /*
         시계방향 (isClockwise == true)
         m_endAngle 기준으로 1분당 6도, 1초당 0.1도
         예) 1분 354도, 5분 330도, 15분 270도, 30분 180도, 45분 90도, 60분 0.01도
         수식 : (2*pi)-(6*m_endAngle)
         분 :
     
         반시계방향 (isClockwise == false)
         m_endAngle 기준으로 1분당 6도, 1초당 0.1도
         예) 1분 6도, 5분 30도, 15분 90도, 30분 180도, 45분 270도, 60분 359.9도
         수식 : 6*m_endAngle
         분 : m_endAngle=6 -> 6/6 = 1분
     */
    public func startTimer(block:@escaping (_ countDown:CGFloat, _ minute:Int, _ second:Int)->(),completion:@escaping ()->()) {
        self.isUserInteractionEnabled = false
        CircleTimer.shared.startCountDown(time: minuteValue, block: { [weak self] (c, m, s) in
            guard let self = `self` else { return }
            block(c, m, s)
            self.drawCircle(time: c/60)
        }) { [weak self] in
            guard let self = `self` else { return }
            completion()
            self.isUserInteractionEnabled = true
        }
    }
    
    //MARK:- 🔶 @private Method
    /// angle을 time으로 변경하는 함수
    private func convertTime(angle:CGFloat) -> CGFloat {
        if isAutoControl {
            return isClockwise ? ((360 - m_end_angle)/6).rounded() : (m_end_angle/6).rounded()
        } else {
            return isClockwise ? ((360 - m_end_angle)/6) : (m_end_angle/6)
        }
    }
    
    /// Circle을 그리는 함수
    private func drawCircle(angle:CGFloat) {
        if angle > -1{
            let standard = 360 + m_start_angle;
            let startAngle = CGFloat(standard).toRadians()
            var tmp = standard - angle
            if(tmp < 0)
            {
                tmp += 360
            }
            let endAngle = CGFloat(tmp).toRadians()
            
            let path = UIBezierPath()
            
            // Move to the centre
            path.move(to: centerPoint)
            // Draw a line to the circumference
            path.addLine(to: CGPoint(x: centerPoint.x + radius * cos(startAngle), y: centerPoint.y + radius * sin(startAngle)))
            // NOW draw the arc
            path.addArc(withCenter: centerPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: isClockwise)
            // Line back to the centre, where we started (or the stroke doesn't work, though the fill does)
            path.addLine(to: CGPoint(x: centerPoint.x, y: centerPoint.y))
            // n.b. as @MartinR points out `cPath.close()` does the same!
            
            m_fill_layer.path = path.cgPath
            m_fill_layer.fillColor = fillColor?.cgColor
        }
    }
    
    private func angleToPoint(_ tapPoint : CGPoint) -> Float {
        let dx = tapPoint.x - centerPoint.x;
        let dy = tapPoint.y - centerPoint.y;
        let radians = atan2(dy,dx); // in radians
        var degrees = radians * 180 / .pi; // in degrees
        
        degrees -= m_start_angle
        
        if (degrees < 0){ return fabsf(Float(degrees))}
        else{ return 360 - Float(degrees) }
    }
    
    private func getLastValue(_ arr:Set<UITouch>) -> UITouch? {
        var rtn_val:UITouch? = nil;
        for tmp in arr {
            rtn_val = tmp
        }
        return rtn_val;
    }
}

fileprivate extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat.pi / 180.0
    }
}



