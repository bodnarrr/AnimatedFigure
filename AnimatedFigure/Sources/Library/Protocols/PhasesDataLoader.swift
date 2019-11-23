//
//  PhasesDataLoader.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation

protocol PhasesDataLoader {
    func loadAnimationPhases(withCompletionHandler completionHandler: @escaping ([AnimationPhase]) -> Void)
}
