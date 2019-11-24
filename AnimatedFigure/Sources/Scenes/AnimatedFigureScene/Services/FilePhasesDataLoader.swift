//
//  FilePhasesDataLoader.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/24/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

class FilePhasesDataLoader: PhasesDataLoader {
    func loadAnimationPhases(withCompletionHandler completionHandler: @escaping ([AnimationPhase]) -> Void) {
        guard let path = Bundle.main.path(forResource: "Phases", ofType: "json") else {
            print("No Phases.json file found in project")
            completionHandler([])
            
            return
        }
        
        guard let fileContent = try? String(contentsOfFile: path) else {
            print("Can't read contents of file")
            completionHandler([])

            return
        }
        
        guard let data = fileContent.data(using: .utf8) else {
            print("String to Data converting error!")
            completionHandler([])
            
            return
        }
        
        guard let phases = try? JSONDecoder().decode([AnimationPhase].self, from: data) else {
            print("Decoding phases from JSON converting error!")
            completionHandler([])
            
            return
        }
        
        completionHandler(phases)
    }
    
}
