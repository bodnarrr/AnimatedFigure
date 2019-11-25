//
//  AnimationOperation.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

class AnimationOperation: BasePhaseOperation {
    
    // MARK: - Properties
    private let animation: () -> Void
    
    // MARK: - Init
    init(startWith: @escaping () -> Void, animation: @escaping () -> Void, duration: TimeInterval) {
        self.animation = animation
        
        super.init(startWith: startWith, duration: duration)
    }
    
    // MARK: - Public Methods
    override func execute() {
        onStart()
        
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.animation()
        }, completion: { _ in
            self.completed()
        })
    }
}
