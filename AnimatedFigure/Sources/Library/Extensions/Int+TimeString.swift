//
//  Int+TimeString.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation

extension Int {
    var timeString: String {
        let minutes = Int(self / 60)
        let seconds = self - minutes * 60
        let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        
        return minutesString + ":" + secondsString
    }
}
