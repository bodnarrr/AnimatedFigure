//
//  AnimatedFigureViewController.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/22/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

// MARK: - Figure Constants
fileprivate enum FigureConstants {
    static let maxFigureToScreenRatio: CGFloat = 0.8
    static let maxFigureSize: CGFloat = {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let size = screenWidth < screenHeight
            ? screenWidth * FigureConstants.maxFigureToScreenRatio
            : screenHeight * FigureConstants.maxFigureToScreenRatio
        
        return size
    }()
    static let defaultFigureRatio: CGFloat = 0.75
}

// MARK: - Controller
class AnimatedFigureViewController: ViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadAnimationData()
    }
    
    // MARK: - Prepare
    override func prepare() {
        prepareFigure()
        preparePhaseInfoLabel()
    }
    
    private func prepareFigure() {
        let square = AnimatedSquare()
        square.frame = CGRect(x: 0, y: 0,
            width: FigureConstants.maxFigureSize * FigureConstants.defaultFigureRatio,
            height: FigureConstants.maxFigureSize * FigureConstants.defaultFigureRatio
        )
        square.backgroundColor = .lightGray
        square.isHidden = true
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
        phaseInfoLabel.isHidden = true
        view.addSubview(phaseInfoLabel)
        
        self.phaseInfoLabel = phaseInfoLabel
    }
    
    private func loadAnimationData() {
        activityIndicator.startAnimating()
        model.loadAnimationPhases(withCompletionHandled: { [weak self] in
            self?.readyToBreathe()
        }, errorHandler: { [weak self] (message) in
            self?.showError(withMesage: message)
        })
    }
    
    // MARK: - Private Methods
    @objc private func breathe() {
        guard operationManager.state != .executing else { return }
        
        model.calcPhasesTime()
        prepareFigureAnimations()
        
        guard operationManager.state == .ready else { return }
        
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
        operationManager
            .onCompletion { [weak self] in
                self?.animatedFigureView?.initialState()
                self?.readyToBreathe()
            }
            .start()
    }
    
    private func readyToBreathe() {
        activityIndicator.stopAnimating()
        phaseInfoLabel?.isHidden = false
        phaseInfoLabel?.text = "TAP TO\nBREATHE"
        phaseInfoLabel?.textColor = .black
        animatedFigureView?.isHidden = false
        remainingTimeLabel.isHidden = true
    }
    
    private func showError(withMesage message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let reloadAction = UIAlertAction(title: "Reload", style: .default) { [weak self] _ in
            self?.loadAnimationData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        [reloadAction, cancelAction].forEach {alert.addAction($0) }
        
        activityIndicator.stopAnimating()
        present(alert, animated: true)
    }
    
}

extension AnimatedFigureViewController: AnimatedFigureDelegate {
    func updatePhaseCounter(forPhase phase: AnimationPhaseType, withRemainingTime remainingTime: Int, color: UIColor) {
        phaseInfoLabel?.text = phase.rawValue.uppercased() + "\n" + remainingTime.timeString
        phaseInfoLabel?.textColor = color
    }
    
    func updateMainCounter() {
        model.updateTotalTime()
        remainingTimeLabel.text = "Remaining\n" + model.totalPhasesTime.timeString
    }
}
