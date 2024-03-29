//
//  AnimatedSquare.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

// MARK: - Square Constants
fileprivate enum SquareConstants {
    static let inhaleRatio: CGFloat = 100 / 75
    static let exhaleRatio: CGFloat = 50 / 75
}

// MARK: - AnimatedSquare
class AnimatedSquare: UIView, AnimatedFigure {
    
    // MARK: - Properties
    var phaseTime = 0
    weak var delegate: AnimatedFigureDelegate?
    
    // MARK: - AnimatedFigure
    func operation(forPhase phase: AnimationPhase) -> PhaseOperation {
        let onStart = prepareOnStart(phase)
        
        let phaseOperation: PhaseOperation
        
        switch phase.type {
        case .inhale:
            let animation: () -> Void = { [weak self] in
                self?.transform = CGAffineTransform(scaleX: SquareConstants.inhaleRatio, y: SquareConstants.inhaleRatio)
            }
            phaseOperation = AnimationOperation(startWith: onStart, animation: animation, duration: phase.duration)
        case .exhale:
            let animation: () -> Void = { [weak self] in
                self?.transform = CGAffineTransform(scaleX: SquareConstants.exhaleRatio, y: SquareConstants.exhaleRatio)
            }
            phaseOperation = AnimationOperation(startWith: onStart, animation: animation, duration: phase.duration)
        case .hold:
            phaseOperation = HoldOperation(startWith: onStart, duration: phase.duration)
        }
        
        return phaseOperation
    }
    
    // MARK: - Private Methods
    private func prepareOnStart(_ phase: AnimationPhase) -> () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            
            self.backgroundColor = phase.color
            self.phaseTime = Int(phase.duration)
            self.delegate?.updatePhaseCounter(forPhase: phase.type, withRemainingTime: self.phaseTime, color: phase.color.contrastingColor)
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] (timer) in
                guard let self = self else {
                    timer.invalidate()
                    return
                }
                
                self.phaseTime -= 1
                self.delegate?.updatePhaseCounter(forPhase: phase.type, withRemainingTime: self.phaseTime, color: phase.color.contrastingColor)
                self.delegate?.updateMainCounter()
                if self.phaseTime == 0 {
                    timer.invalidate()
                }
            }
        }
    }
}
