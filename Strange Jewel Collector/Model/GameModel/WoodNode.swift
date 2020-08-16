//
//  WoodNode.swift
//  Wolf Treasure Adventure
//
//  Created by Виктор on 26.07.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import SpriteKit

extension GameScene {
    func addWoodToScene(_ position: CGPoint, _ rotation: CGFloat) {
        let wood = SKSpriteNode(imageNamed: ImageName.woodTexture)
        wood.size = CGSize(width: 100, height: 10)
        wood.position = CGPoint(x: position.x, y: position.y)
        wood.zRotation = .pi / rotation
        wood.zPosition = Layers.wood
        wood.physicsBody = SKPhysicsBody(texture:  SKTexture(imageNamed: ImageName.woodTexture), size: wood.size)
        wood.physicsBody?.categoryBitMask = PhysicsCategoryBitMask.wood
        wood.physicsBody?.collisionBitMask = PhysicsCategoryBitMask.prize
        wood.physicsBody?.restitution = 0.75
        wood.physicsBody?.isDynamic = false

       addChild(wood)
    }
}

