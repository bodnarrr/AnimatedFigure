//
//  AnimatedSquare.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

class AnimatedSquare: UIView, AnimatedFigure {
    
    // MARK: - AnimatedFigure
    func operation(forPhase phase: AnimationPhase) -> PhaseOperation {
        let onStart: () -> Void = { [weak self] in
            self?.backgroundColor = phase.color
        }
        
        let phaseOperation: PhaseOperation
        
        switch phase.type {
        case .inhale:
            let animation: () -> Void = { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 4 / 3, y: 4 / 3)
            }
            phaseOperation = AnimationOperation(startWith: onStart, animation: animation, duration: phase.duration)
        case .exhale:
            let animation: () -> Void = { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 2 / 3, y: 2 / 3)
            }
            phaseOperation = AnimationOperation(startWith: onStart, animation: animation, duration: phase.duration)
        case .hold:
            phaseOperation = HoldOperation(startWith: onStart, duration: phase.duration)
        }
        
        return phaseOperation
    }
    
}
