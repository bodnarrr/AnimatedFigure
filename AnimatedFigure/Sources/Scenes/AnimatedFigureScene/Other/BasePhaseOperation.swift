//
//  BasePhaseOperation.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/25/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation

class BasePhaseOperation: PhaseOperation {
    
    // MARK: - Properties
    private(set) var completed: () -> Void = { }
    private(set) var onStart: () -> Void
    private(set) var duration: TimeInterval
    
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
    
    open func execute() {
        fatalError("execute() method must be implemented.")
    }
    
    
}
