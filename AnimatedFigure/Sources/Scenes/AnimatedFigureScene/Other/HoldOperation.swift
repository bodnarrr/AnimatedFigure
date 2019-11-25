//
//  HoldOperation.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation

class HoldOperation: BasePhaseOperation {
    
    // MARK: - Public Methods
    override func execute() {
        onStart()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.completed()
        }
    }
    
    
}
