//
//  AnimatedFigureViewController.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/22/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

class AnimatedFigureViewController: ViewController {
    
    // MARK: - Properties
    let model: AnimatedFigureModel

    // MARK: - Init
    init(withModel model: AnimatedFigureModel) {
        self.model = model
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Class is designed to be used with xib.")
    }
    
    // MARK: - Prepare
    override func prepare() {
        model.loadAnimationPhases { [weak self] in
            self?.model.animationPhases.forEach { (phase) in
                DispatchQueue.main.asyncAfter(deadline: .now() + phase.duration) { [weak self] in
                    self?.view.backgroundColor = phase.color
                }
            }
        }
    }
    
}
