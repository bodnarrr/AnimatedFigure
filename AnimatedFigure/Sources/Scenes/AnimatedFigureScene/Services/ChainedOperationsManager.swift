//
//  ChainedOperationsManager.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

// MARK: - AsyncOperationProtocol
protocol AsyncOperation {
    func onCompleted(_ completed: @escaping () -> Void) -> Self
    func execute()
}

// MARK: - ChainedOperationsManager
class ChainedOperationsManager {
    
    // MARK: - Properties
    var completion: (() -> Void) = { }
    private var chain = [AsyncOperation]()
    
    // MARK: - Public Methods
    @discardableResult
    func addOperation(operation: AsyncOperation) -> Self {
        chain.append(operation)
        
        return self
    }
    
    @discardableResult
    func onCompletion(_ chainCompletion: @escaping () -> Void) -> Self {
        completion = chainCompletion
        
        return self
    }
    
    func start() {
        executeChain()
    }
    
    // MARK: - Private Methods
    private func executeChain() {
        guard !chain.isEmpty else {
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
