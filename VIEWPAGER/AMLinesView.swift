//
//  AMLinesViews.swift
//  MusicAppWorld
//
//  Created by Shikha on 03/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//
import UIKit

class AMLineView: UIView {
    
    var lineHeight: CGFloat = 2
    var lineColor = UIColor.darkGray
    
    override func draw(_ rect: CGRect) {
        drawSelectedTabLine()
    }
    
    private func drawSelectedTabLine(){
        let height = frame.height
        let width = frame.width
        let triangleSize:CGFloat = 0
        
        let path = UIBezierPath()
        // draw the lines of the shape
        path.move(to: CGPoint(x: 0, y: height-lineHeight))
        path.addLine(to: CGPoint(x: (width/1)-triangleSize, y: height-lineHeight))
        path.addLine(to: CGPoint(x: (width/1), y: height-lineHeight-triangleSize))
        path.addLine(to: CGPoint(x: (width/1)+triangleSize , y: height-lineHeight))
        path.addLine(to: CGPoint(x: width , y: height-lineHeight))
        path.addLine(to: CGPoint(x: width , y: height))
        path.addLine(to: CGPoint(x: 0 , y: height))
        path.addLine(to: CGPoint(x: 0 , y: height-lineHeight))
        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        clipsToBounds = true
    }
    
    
}
