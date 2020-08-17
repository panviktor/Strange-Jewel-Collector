//
//  Grid.swift
//  Wolf Treasure Adventure
//
//  Created by Viktor on 05.08.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import SpriteKit

class Grid: SKSpriteNode {
    var rows: Int!
    var columns: Int!
    var blockSize: CGFloat!

    convenience init?(blockSize: CGFloat, rows: Int, columns: Int) {
        guard let texture = Grid.gridTexture(blockSize: blockSize, rows: rows, columns: columns) else {
            return nil
        }
        self.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.blockSize = blockSize
        self.rows = rows
        self.columns = columns
    }

    class func gridTexture(blockSize: CGFloat, rows: Int, columns: Int) -> SKTexture? {
        // Add 1 to the height and width to ensure the borders are within the sprite
        let size = CGSize(width: CGFloat(columns) * blockSize + 1.0, height: CGFloat(rows) * blockSize + 1.0)
        UIGraphicsBeginImageContext(size)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let bezierPath = UIBezierPath()
        let offset: CGFloat = 0.5
        // Draw vertical lines
        for i in 0...columns {
            let x = CGFloat(i) * blockSize + offset
            bezierPath.move(to: CGPoint(x: x, y: 0))
            bezierPath.addLine(to: CGPoint(x: x, y: size.height))
        }
        // Draw horizontal lines
        for i in 0...rows {
            let y = CGFloat(i) * blockSize + offset
            bezierPath.move(to: CGPoint(x: 0, y: y))
            bezierPath.addLine(to: CGPoint(x: size.width, y: y))
        }
        SKColor.white.setStroke()
        bezierPath.lineWidth = 0.1
        bezierPath.stroke()
        context.addPath(bezierPath.cgPath)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return SKTexture(image: image!)
    }

    func gridPosition(row:Int, column:Int) -> CGPoint {
        let offset = blockSize / 2.0 + 0.5
        let x = CGFloat(column) * blockSize - (blockSize * CGFloat(columns)) / 2.0 + offset
        let y = CGFloat(rows - row - 1) * blockSize - (blockSize * CGFloat(rows)) / 2.0 + offset
        return CGPoint(x: x, y: y)
    }
}
