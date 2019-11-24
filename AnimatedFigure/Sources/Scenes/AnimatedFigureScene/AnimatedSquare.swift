//
//  AnimatedSquare.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

class AnimatedSquare: UIView, AnimatedFigure {
    
    // MARK: - Properties
    var phaseTime = 0
    weak var delegate: AnimatedFigureDelegate?
    
    // MARK: - AnimatedFigure
    func operation(forPhase phase: AnimationPhase) -> PhaseOperation {
        let onStart: () -> Void = { [weak self] in
            guard let self = self else { return }
            
            self.backgroundColor = phase.color
            self.phaseTime = Int(phase.duration)
            self.delegate?.animatedFigure(didUpdatePhase: phase.type, withRemainingTime: self.phaseTime)
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] (timer) in
                guard let self = self else {
                    timer.invalidate()
                    return
                }
                
                self.phaseTime -= 1
                self.delegate?.animatedFigure(didUpdatePhase: phase.type, withRemainingTime: self.phaseTime)
                if self.phaseTime == 0 {
                    timer.invalidate()
                }
            }
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
