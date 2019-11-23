//
//  AnimationPhase.swift
//  AnimatedFigure
//
//  Created by Andrii Bodnar on 11/23/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import UIKit

enum ColorDecodingError: Error {
    case incorrectHex(String)
}

enum AnimationPhaseType: String, Codable {
    case inhale
    case exhale
    case hold
}

struct AnimationPhase: Codable {
    
    // MARK: - Properties
    let type: AnimationPhaseType
    let duration: TimeInterval
    let color: UIColor
    
    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case type
        case duration
        case color
    }
    
    // MARK: - Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(AnimationPhaseType.self, forKey: .type)
        duration = try container.decode(TimeInterval.self, forKey: .duration)
        
        // TODO: Color from string init
        let colorHexString = try container.decode(String.self, forKey: .color)
        guard let color = UIColor(hexString: colorHexString) else {
            throw ColorDecodingError.incorrectHex("Incorrect color format")
        }
        self.color = color
    }
    
    // MARK: - Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(duration, forKey: .duration)
        try container.encode(color.hexString, forKey: .color)
    }
}
