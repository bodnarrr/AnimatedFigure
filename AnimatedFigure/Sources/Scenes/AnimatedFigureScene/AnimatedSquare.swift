//
//  AnimatedSquare.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

class AnimatedSquare: UIView, AnimatedFigure {
    
    // MARK: - Properties
    var phaseLabel: UILabel?
    var timeLabel: UILabel?
    
    var phaseTime = 0
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        createPhaseLabel()
        createTimeLable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createPhaseLabel() {
        let phaseLabel = UILabel()
        phaseLabel.text = "HELLO"
        phaseLabel.translatesAutoresizingMaskIntoConstraints = false
        phaseLabel.textAlignment = .center
        addSubview(phaseLabel)
        bringSubviewToFront(phaseLabel)
        self.phaseLabel = phaseLabel
    }
    
    private func createTimeLable() {
        let timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textAlignment = .center
        addSubview(timeLabel)
        bringSubviewToFront(timeLabel)
        self.timeLabel = timeLabel
    }
    
    // MARK: - LifeCycle
    override func layoutSubviews() {
        preparePhaseLabel()
    }
    
    private func preparePhaseLabel() {
        guard let phaseLabel = phaseLabel, let timeLabel = timeLabel else { return }
        
        [phaseLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
         phaseLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
         phaseLabel.widthAnchor.constraint(equalToConstant: 80),
         phaseLabel.heightAnchor.constraint(equalToConstant: 20)]
            .forEach { $0?.isActive = true }
        
        [timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
         timeLabel.topAnchor.constraint(equalTo: phaseLabel.bottomAnchor),
         timeLabel.widthAnchor.constraint(equalToConstant: 80),
         timeLabel.heightAnchor.constraint(equalToConstant: 20)]
            .forEach { $0?.isActive = true }
        
    }
    
    // MARK: - AnimatedFigure
    func operation(forPhase phase: AnimationPhase) -> PhaseOperation {
        let onStart: () -> Void = { [weak self] in
            self?.backgroundColor = phase.color
            self?.phaseLabel?.text = phase.type.rawValue.uppercased()
            self?.phaseTime = Int(phase.duration)
            self?.timeLabel?.text = self?.phaseTime.timeString
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] (timer) in
                guard let self = self else {
                    timer.invalidate()
                    return
                }
                self.phaseTime -= 1
                let timerIsFinished = self.phaseTime == 0
                self.timeLabel?.text = self.phaseTime.timeString
                if timerIsFinished { timer.invalidate() }
            }
        }
        
        let phaseOperation: PhaseOperation
        
        switch phase.type {
        case .inhale:
            let animation: () -> Void = { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 4 / 3, y: 4 / 3)
            }
            phaseOperation = AnimationOperation(startWith: onStart, animation: animation, duration: phase.duration)
        case .exhale:
            let animation: () -> Void = { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 2 / 3, y: 2 / 3)
            }
            phaseOperation = AnimationOperation(startWith: onStart, animation: animation, duration: phase.duration)
        case .hold:
            phaseOperation = HoldOperation(startWith: onStart, duration: phase.duration)
        }
        
        return phaseOperation
    }
    
}
