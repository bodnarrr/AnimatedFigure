//
//  AnimationOperation.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

class AnimationOperation: AsyncOperation {
    
    // MARK: - Properties
    private var completed: () -> Void = { }
    private let onStart: () -> Void
    private let animation: () -> Void
    
    // MARK: - Init
    init(startWith: @escaping () -> Void, animation: @escaping () -> Void) {
        self.onStart = startWith
        self.animation = animation
    }
    
    // MARK: - Public Methods
    @discardableResult
    func onCompleted(_ completed: @escaping () -> Void) -> Self {
        self.completed = completed
        
        return self
    }
    
    func execute() {
        onStart()
        UIView.animate(withDuration: 1.0, animations: { [weak self] in
            self?.animation()
        }, completion: { _ in
            self.completed()
        })
    }
}
