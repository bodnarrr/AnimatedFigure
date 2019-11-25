//
//  FilePhasesDataLoader.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/24/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

class FilePhasesDataLoader: PhasesDataLoader {
    func loadAnimationPhases(withCompletionHandler completionHandler: @escaping (Result<[AnimationPhase], DataLoadingError>) -> Void) {
        guard let path = Bundle.main.path(forResource: "Phases", ofType: "json") else {
            completionHandler(.failure(.dataError("No Phases.json file found in project")))
            
            return
        }
        
        guard let fileContent = try? String(contentsOfFile: path) else {
            completionHandler(.failure(.dataError("Can't read contents of file")))

            return
        }
        
        guard let data = fileContent.data(using: .utf8) else {
            completionHandler(.failure(.dataError("String to Data converting error!")))
            
            return
        }
        
        guard let phases = try? JSONDecoder().decode([AnimationPhase].self, from: data) else {
            completionHandler(.failure(.dataError("Decoding phases from JSON converting error!")))
            
            return
        }
        
        completionHandler(.success(phases))
    }
    
}
