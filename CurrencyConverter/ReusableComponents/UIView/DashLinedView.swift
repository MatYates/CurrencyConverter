//
//  DashLinedView.swift
//  CurrencyConverter
//
//  Created by Mat Yates on 15/1/21.
//

import UIKit

@IBDesignable class DashLinedView: UIView {
    
    @IBInspectable var dashLength: CGFloat = 10.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var spaceBetweenDashes: CGFloat = 5.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var dashColor: UIColor = UIColor.darkGray{
        didSet {
            self.setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.drawDashedLine()
    }
    
    private let path = UIBezierPath()
    
    private func drawDashedLine() {
        self.path.removeAllPoints()
        if self.height > self.width {
            let path0 = CGPoint(x: self.bounds.midX, y: self.bounds.minY)
            path.move(to: path0)
            let path1 = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
            path.addLine(to: path1)
            path.lineWidth = width

        } else {
            let path0 = CGPoint(x: self.bounds.minX, y: self.bounds.midY)
            path.move(to: path0)
            let path1 = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
            path.addLine(to: path1)
            path.lineWidth = height
        }

        let dashes: [CGFloat] = [dashLength, spaceBetweenDashes]
        
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        path.lineCapStyle = .butt
        dashColor.set()
        path.stroke()
    }
    
    private var width : CGFloat {
        return self.bounds.width
    }

    private var height : CGFloat {
        return self.bounds.height
    }
}
