//
//  AnimatedFigure.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

protocol AnimatedFigure: UIView {
    typealias PhaseOperation = () -> Void
    
    func operation(forPhase phase: AnimationPhase) -> PhaseOperation
}
