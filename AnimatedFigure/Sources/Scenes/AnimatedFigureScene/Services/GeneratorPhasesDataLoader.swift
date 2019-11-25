//
//  GeneratorPhasesDataLoader.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation

class GeneratorPhasesDataLoader: PhasesDataLoader {
    func loadAnimationPhases(withCompletionHandler completionHandler: @escaping (Result<[AnimationPhase], DataLoadingError>) -> Void) {
        let phaseOne: [String: Any] = [
            "type": "inhale",
            "duration": 5,
            "color": "#FF00FF"
        ]
        let phaseTwo: [String: Any] = [
            "type": "exhale",
            "duration": 4,
            "color": "#00FFFF"
        ]
        let phaseThree: [String: Any] = [
            "type": "hold",
            "duration": 3,
            "color": "#4340C1"
        ]
        let phaseFour: [String: Any] = [
            "type": "inhale",
            "duration": 2,
            "color": "#FF00FF"
        ]
        let phaseFive: [String: Any] = [
            "type": "exhale",
            "duration": 1,
            "color": "#A00F1F"
        ]
        
        let generatedPhases = [phaseOne, phaseTwo, phaseThree, phaseFour, phaseFive]
        guard let phasesData = try? JSONSerialization.data(withJSONObject: generatedPhases, options: []) else {
            completionHandler(.failure(.dataError("Generated phases to JSON converting error!")))
            
            return
        }
        guard let phases = try? JSONDecoder().decode([AnimationPhase].self, from: phasesData) else {
            completionHandler(.failure(.dataError("Decoding phases from JSON converting error!")))
            
            return
        }
        
        completionHandler(.success(phases))
    }
}
