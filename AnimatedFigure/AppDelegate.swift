//
//  AppDelegate.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/22/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        
        let dataLoader = GeneratorPhasesDataLoader()
        let model = AnimatedFigureModel(phasesDataLoader: dataLoader)
        let animatedFigureViewController = AnimatedFigureViewController(withModel: model)
        window?.rootViewController = animatedFigureViewController
        window?.makeKeyAndVisible()
        
        return true
    }


}

