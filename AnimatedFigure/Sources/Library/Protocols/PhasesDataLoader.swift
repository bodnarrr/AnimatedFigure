//
//  PhasesDataLoader.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation

enum DataLoadingError: Error {
    case dataError(String)
    
    var errorMessage: String {
        switch self {
        case .dataError(let errorMessage):
            return errorMessage
        }
    }
}

protocol PhasesDataLoader {
    func loadAnimationPhases(withCompletionHandler completionHandler: @escaping (Result<[AnimationPhase], DataLoadingError>) -> Void)
}
