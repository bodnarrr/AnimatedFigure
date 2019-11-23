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
    let maxSize: CGFloat
    
    // MARK: - Init
    init(withMaxSize maxSize: CGFloat) {
        self.maxSize = maxSize
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - AnimatedFigure
    func operation(forPhase phase: AnimationPhase) -> PhaseOperation {
        let onStart: () -> Void = { [weak self] in
            self?.backgroundColor = phase.color
        }
        
        let animation: () -> Void
        switch phase.type {
        case .inhale:
            animation = { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 2, y: 2)
            }
        case .exhale:
            animation = { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
        case .hold:
            animation = { }
        }
        let phaseOperation = AnimationOperation(startWith: onStart, animation: animation, duration: phase.duration)
        
        return phaseOperation
    }
    
}
