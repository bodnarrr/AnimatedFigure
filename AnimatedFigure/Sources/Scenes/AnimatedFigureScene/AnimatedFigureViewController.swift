//
//  AnimatedFigureViewController.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/22/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

class AnimatedFigureViewController: ViewController {
    typealias PhaseOperation = () -> Void
    
    // MARK: - Outlets
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    // MARK: - Properties
    let model: AnimatedFigureModel
    let operationManager = ChainedOperationsManager()
    var animatedFigureView: AnimatedFigure?
    var phaseInfoLabel: UILabel?

    // MARK: - Init
    init(withModel model: AnimatedFigureModel) {
        self.model = model
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Class is designed to be used with xib.")
    }
    
    // MARK: - LifeCycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        animatedFigureView?.center = view.center
        phaseInfoLabel?.center = view.center
    }
    
    // MARK: - Prepare
    override func prepare() {
        prepareFigure()
        preparePhaseInfoLabel()
        prepareAnimationData()
    }
    
    private func prepareFigure() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let maxFigureSize = screenWidth < screenHeight ? screenWidth * 0.8 : screenHeight * 0.8
        
        let square = AnimatedSquare()
        square.frame = CGRect(x: 0, y: 0, width: maxFigureSize * 0.75, height: maxFigureSize * 0.75)
        square.backgroundColor = .lightGray
        square.delegate = self
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(breathe))
        square.addGestureRecognizer(tapRecognizer)
        
        view.addSubview(square)
        animatedFigureView = square
    }
    
    private func preparePhaseInfoLabel() {
        let phaseInfoLabel = UILabel()
        phaseInfoLabel.numberOfLines = 0
        phaseInfoLabel.frame = CGRect(x: 0, y: 0, width: 90, height: 60)
        phaseInfoLabel.textAlignment = .center
        view.addSubview(phaseInfoLabel)
        
        self.phaseInfoLabel = phaseInfoLabel
    }
    
    private func prepareAnimationData() {
        model.loadAnimationPhases { [weak self] in
            self?.breathe()
        }
    }
    
    // MARK: - Private Methods
    @objc private func breathe() {
        guard operationManager.state != .executing else { return }
        
        model.calcPhasesTime()
        prepareFigureAnimations()
        prepareTimeLabel()
        startBreathe()
    }
    
    private func prepareFigureAnimations() {
        model.animationPhases
            .compactMap { [weak self] (phase) in
            self?.animatedFigureView?.operation(forPhase: phase)
            }
            .forEach { [weak self] (operation) in
                self?.operationManager.addOperation(operation: operation)
            }
    }
    
    private func prepareTimeLabel() {
        remainingTimeLabel.isHidden = false
        remainingTimeLabel.text = "Remaining\n" + model.totalPhasesTime.timeString
    }
    
    private func startBreathe() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            self?.model.updateTotalTime()
            
            guard let remainingTime = self?.model.totalPhasesTime else { return }
            if remainingTime == 0 {
                timer.invalidate()
                self?.remainingTimeLabel.isHidden = true
            } else {
                self?.remainingTimeLabel.text = "Remaining\n" + remainingTime.timeString
            }
        })
        operationManager
            .onCompletion { [weak self] in
                self?.animatedFigureView?.initialState()
                self?.phaseInfoLabel?.text = "TAP TO\nBREATHE"
            }
            .start()
    }
}

extension AnimatedFigureViewController: AnimatedFigureDelegate {
    func animatedFigure(didUpdatePhase phase: AnimationPhaseType, withRemainingTime remainingTime: Int) {
        phaseInfoLabel?.text = phase.rawValue.uppercased() + "\n" + remainingTime.timeString
    }
}
