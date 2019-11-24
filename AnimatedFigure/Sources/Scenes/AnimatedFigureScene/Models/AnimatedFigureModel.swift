//
//  AnimatedFigureModel.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation

class AnimatedFigureModel {
    
    // MARK: - Properties
    private let phasesDataLoader: PhasesDataLoader
    var animationPhases: [AnimationPhase] = []
    var totalPhasesTime: Int = 0
    
    // MARK: - Init
    init(phasesDataLoader: PhasesDataLoader) {
        self.phasesDataLoader = phasesDataLoader
    }
    
    // MARK: - Public methods
    func loadAnimationPhases(withCompletionHandled completionHandler: @escaping () -> Void) {
        phasesDataLoader.loadAnimationPhases { [weak self] (phases) in
            self?.animationPhases = phases
            completionHandler()
        }
    }
    
    func calcPhasesTime() {
        totalPhasesTime = animationPhases.reduce(0, { (time, phase) -> Int in
            time + Int(phase.duration)
        })
    }
    
    func updateTotalTime() {
        totalPhasesTime -= 1
    }
}
