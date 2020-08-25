//
//  Extension+SKShader.swift
//  Strange Jewel Collector
//
//  Created by Viktor on 25.08.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import SpriteKit

extension SKShader {
    convenience init(fromFile filename: String, uniforms: [SKUniform]? = nil, attributes: [SKAttribute]? = nil) {
        guard let path = Bundle.main.path(forResource: filename, ofType: "fsh") else {
            fatalError("Unable to find shader \(filename).fsh in bundle")
        }

        guard let source = try? String(contentsOfFile: path) else {
            fatalError("Unable to load shader \(filename).fsh")
        }

        if let uniforms = uniforms {
            self.init(source: source as String, uniforms: uniforms)
        } else {
            self.init(source: source as String)
        }

        if let attributes = attributes {
            self.attributes = attributes
        }
    }
}
