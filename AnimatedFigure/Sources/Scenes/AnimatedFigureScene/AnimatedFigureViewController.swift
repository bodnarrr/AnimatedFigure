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
        
        let square = AnimatedSquare(withMaxSize: CGFloat(maxFigureSize))
        view.addSubview(square)
        
        square.frame = CGRect(x: 100, y: 400, width: 100, height: 100)
        square.backgroundColor = .lightGray
        animatedFigureView = square
    }
    
    private func prepareAnimationData() {
        model.loadAnimationPhases { [weak self] in
            self?.prepareMainTimer()
            self?.animateFigure()
        }
    }
    
    // MARK: - Private Methods
    private func prepareMainTimer() {
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
    }
    
    @objc private func animateFigure() {
        let firstOperation = AnimationOperation(startWith: {
            print("on start 1")
        }, animation: { [weak self] in
            self?.animatedFigureView?.transform = CGAffineTransform(scaleX: 2, y: 2)
        })
        let secondOperation = AnimationOperation(startWith: {
            print("on start 2")
        }, animation: { [weak self] in
            self?.animatedFigureView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        })
        
        [firstOperation, secondOperation].forEach {
            operationManager.addOperation(operation: $0)
        }
        operationManager.onCompletion {
            print("finished all tasks")
        }
        .start()
        
        
    }

}
