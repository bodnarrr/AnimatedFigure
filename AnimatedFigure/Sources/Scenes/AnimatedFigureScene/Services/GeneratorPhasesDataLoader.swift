//
//  GeneratorPhasesDataLoader.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation

class GeneratorPhasesDataLoader: PhasesDataLoader {
    func loadAnimationPhases(withCompletionHandler completionHandler: @escaping ([AnimationPhase]) -> Void) {
        let phaseOne: [String: Any] = [
            "type": "inhale",
            "duration": 4,
            "color": "#FF00FF"
        ]
        let phaseTwo: [String: Any] = [
            "type": "exhale",
            "duration": 2,
            "color": "#00FFFF"
        ]
        let phaseThree: [String: Any] = [
            "type": "hold",
            "duration": 7,
            "color": "#FFFF00"
        ]
        
        let generatedPhases = [phaseOne, phaseTwo, phaseThree]
        guard let phasesData = try? JSONSerialization.data(withJSONObject: generatedPhases, options: []) else {
            print("Generated phases to JSON converting error!")
            return
        }
        guard let phases = try? JSONDecoder().decode([AnimationPhase].self, from: phasesData) else {
            print("Decoding phases from JSON converting error!")
            return
        }
        
        completionHandler(phases)
    }
    
    
}
