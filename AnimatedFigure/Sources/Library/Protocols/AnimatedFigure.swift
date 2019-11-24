//
//  AnimatedFigure.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

protocol AnimatedFigureDelegate: class {
    func animatedFigure(didUpdatePhase phase: AnimationPhaseType, withRemainingTime remainingTime: Int)
}

protocol AnimatedFigure: UIView {
    func operation(forPhase phase: AnimationPhase) -> PhaseOperation
}
