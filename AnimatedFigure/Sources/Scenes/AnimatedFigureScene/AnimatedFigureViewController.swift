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
    var timer: Timer?

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
    }
    
    // MARK: - Prepare
    override func prepare() {
        prepareFigure()
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
        
        view.addSubview(square)
        animatedFigureView = square
    }
    
    private func prepareAnimationData() {
        model.loadAnimationPhases { [weak self] in
            self?.prepareFigureAnimations()
            self?.prepareTimeLabel()
            self?.startBreathing()
        }
    }
    
    // MARK: - Private Methods
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
        remainingTimeLabel.text = "Remaining\n" + model.totalPhasesTime.timeString
    }
    
    private func startBreathing() {
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
            .onCompletion {
                print("~~~> Finished animations")
            }
            .start()
    }
}

extension AnimatedFigureViewController: AnimatedFigureDelegate {
    func animatedFigure(didUpdatePhase phase: AnimationPhaseType, withRemainingTime remainingTime: Int) {
        print("Phase: \(phase.rawValue), time: \(remainingTime)")
    }
}
