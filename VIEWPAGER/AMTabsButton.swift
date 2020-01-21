//
//  AMTabsButtons.swift
//  MusicAppWorld
//
//  Created by Shikha on 03/10/19.
//  Copyright © 2019 webcreaters. All rights reserved.
//

import UIKit

class AMTabButton: UIButton {
    
    var index: Int?
    
    override func draw(_ rect: CGRect) {
        addTabSeparatorLine()
    }
    
    private func addTabSeparatorLine(){
        let gradientMaskLayer: CAGradientLayer = CAGradientLayer()
        gradientMaskLayer.frame = self.bounds
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientMaskLayer.locations = [0.0, 0.0]
        gradientMaskLayer.frame = CGRect(x: 0, y: 0, width: 0.0, height: self.frame.height)
        self.layer.addSublayer(gradientMaskLayer)
    }
    
}
