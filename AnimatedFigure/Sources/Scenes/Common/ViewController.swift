//
//  ViewController.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/22/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

/// Base Controller class to use in application
/// With init from xib and setupping methods
/// Override `initialSetup()` and `prepare()` to customize
class ViewController: UIViewController {
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Class is designed to be used with xib.")
    }
    
    open func initialSetup() {}
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
    }
    
    open func prepare() {}
}
