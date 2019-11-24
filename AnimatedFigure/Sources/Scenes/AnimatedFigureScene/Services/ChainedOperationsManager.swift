//
//  ChainedOperationsManager.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

enum ChainedOperationsManagerState {
    case executing
    case ready
    case empty
}

class ChainedOperationsManager {
    
    // MARK: - Properties
    var completion: (() -> Void) = { }
    private var chain = [PhaseOperation]()
    private(set) var state: ChainedOperationsManagerState = .empty
    
    // MARK: - Public Methods
    @discardableResult
    func addOperation(operation: PhaseOperation) -> Self {
        chain.append(operation)
        state = .ready
        
        return self
    }
    
    @discardableResult
    func onCompletion(_ chainCompletion: @escaping () -> Void) -> Self {
        completion = chainCompletion
        
        return self
    }
    
    func start() {
        guard state == .ready else { return }
        
        state = .executing
        executeChain()
    }
    
    // MARK: - Private Methods
    private func executeChain() {
        guard !chain.isEmpty else {
            state = .empty
            completion()
            return
        }
        
        let operation = chain.removeFirst()
        operation
            .onCompleted { [weak self] in
                self?.executeChain()
            }
            .execute()
    }
}
