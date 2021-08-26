//
//  DashLine.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/24.
//

import UIKit

final class DashLine: UIView {
    override func draw(_ rect: CGRect) {
        self.drawDash()
    }
    
    private func drawDash() {
        let  path = UIBezierPath()

        let  p0 = CGPoint(x: self.bounds.minX, y: self.bounds.midY)
        path.move(to: p0)

        let  p1 = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
        path.addLine(to: p1)

        let  dashes: [ CGFloat ] = [ 8.5, 4.5 ]
        path.setLineDash(dashes, count: dashes.count, phase: 5.0)

        path.lineWidth = 1.5
        path.lineCapStyle = .butt
        UIColor.black_100.set()
        path.stroke()
    }
}
