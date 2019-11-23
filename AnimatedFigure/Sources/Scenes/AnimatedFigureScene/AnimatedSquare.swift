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
        return { }
    }
    
}