//
//  PhaseOperation.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/24/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation

protocol PhaseOperation {
    func onCompleted(_ completed: @escaping () -> Void) -> Self
    func execute()
}
