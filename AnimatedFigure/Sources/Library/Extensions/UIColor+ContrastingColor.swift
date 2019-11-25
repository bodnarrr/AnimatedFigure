//
//  UIColor+ContrastingColor.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/25/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

extension UIColor {
    var contrastingColor: UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let yiq = ((r * 255 * 299) + (g * 255 * 587) + (b * 255 * 114)) / 1000;
        let isDark = yiq < 128
        
        return isDark ? .white : .black
    }
}
