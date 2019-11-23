//
//  AnimatedFigure.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

protocol AnimatedFigure: UIView {
    typealias SizeChangingOperation = () -> Void
    
    var maxSize: CGFloat { get }
    
    func exhale() -> SizeChangingOperation
    func inhale() -> SizeChangingOperation
    func hold() -> SizeChangingOperation
}
