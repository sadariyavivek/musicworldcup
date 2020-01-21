//
//  DashedLineView.swift
//  MusicAppWorld
//
//  Created by Webcreaters on 16/11/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//


import UIKit

class DashedLineView: UIView {

    override func draw(_ rect: CGRect) {

        let path = UIBezierPath(roundedRect: rect, cornerRadius: 8)

        UIColor.clear.setFill()
        path.fill()

        UIColor.darkGray.setStroke()
        path.lineWidth = 3

        let dashPattern : [CGFloat] = [3, 3]
        path.setLineDash(dashPattern, count: 2, phase: 0)
        path.stroke()
    }
}
