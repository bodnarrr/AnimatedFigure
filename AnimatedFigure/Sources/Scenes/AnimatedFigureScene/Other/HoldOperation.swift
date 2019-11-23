//
//  HoldOperation.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation

class HoldOperation: PhaseOperation {
    // MARK: - Properties
    private var completed: () -> Void = { }
    private let onStart: () -> Void
    private let duration: TimeInterval
    
    // MARK: - Init
    init(startWith: @escaping () -> Void, duration: TimeInterval) {
        self.onStart = startWith
        self.duration = duration
    }
    
    // MARK: - Public Methods
    @discardableResult
    func onCompleted(_ completed: @escaping () -> Void) -> Self {
        self.completed = completed
        
        return self
    }
    
    func execute() {
        onStart()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.completed()
        }
    }
    
    
}
