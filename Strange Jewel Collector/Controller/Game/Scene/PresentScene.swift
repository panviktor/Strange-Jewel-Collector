//
//  PresentScene.swift
//  Wolf Treasure Adventure
//
//  Created by Viktor on 04.08.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import SpriteKit

class PresentScene: SKScene {
    private enum State {
        case Select
    }
    
    private enum PresentSceneButton: String {
        case BackButton
        case ApplyButton
    }
    
    private let scoreNode = SKSpriteNode()
    private let buttonNode = SKSpriteNode()
    private let mainBoard = SKSpriteNode()
    
    private var state: State = .Select
    private let sceneManager = SceneManager.shared
    private let audioVibroManager = AudioVibroManager.shared
    private let gameManager = GameManager.shared
    private let screenSize: CGRect = UIScreen.main.bounds
    private var presentNumber = 1
        
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        loadBackground()
    }
    
    private func loadBackground() {
        let loadBackground = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.PresentScene.presentSceneBackground))
        loadBackground.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        loadBackground.size = CGSize(width: screenSize.width, height: screenSize.height)
        loadBackground.zPosition = -10
        
        let titleLabel = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.PresentScene.presentSceneTextLabel))
        titleLabel.anchorPoint = CGPoint(x: 0.0, y: 0.65)
        titleLabel.size = CGSize(width: screenSize.width, height: screenSize.height * 0.15)
        titleLabel.position.y = screenSize.size.height * 0.915
        titleLabel.zPosition = -9
        
        mainBoard.texture = SKTexture(imageNamed: ImageName.PresentScene.presentSceneMainBoard)
        mainBoard.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        mainBoard.size = CGSize(width: screenSize.width * 0.98, height: screenSize.width * 0.98)
        mainBoard.position.x = screenSize.width - screenSize.width * 0.99
        mainBoard.position.y = (titleLabel.position.y - (titleLabel.size.width / 4.5))
        mainBoard.zPosition = -9
        
        buttonNode.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        buttonNode.size = titleLabel.size
        buttonNode.position.y = mainBoard.position.y - mainBoard.size.height - (mainBoard.size.height * 0.05)
        
        self.addChild(loadBackground)
        self.addChild(titleLabel)
        self.addChild(mainBoard)
        self.addChild(buttonNode)
        
        addButton()
        presentGrid()
        try? audioVibroManager.playMusic(type: .priceSceneBackground)
    }
    
    private func addButton() {
        let backButton = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.PresentScene.presentSceneBackButton))
        backButton.name = PresentSceneButton.BackButton.rawValue
        backButton.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        backButton.position = CGPoint(x: buttonNode.size.width * 0.025, y: 0)
        backButton.size = CGSize(width:  buttonNode.size.width / 2.20,
                                 height: buttonNode.size.height * 0.95)
        
        let applyButton = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.PresentScene.presentSceneApplyButton))
        applyButton.name = PresentSceneButton.ApplyButton.rawValue
        applyButton.anchorPoint = CGPoint(x: 1, y: 1.0)
        applyButton.position = CGPoint(x: buttonNode.size.width * 0.975, y: 0)
        applyButton.size = CGSize(width:  buttonNode.size.width / 2.20,
                                  height: buttonNode.size.height * 0.95)
        
        buttonNode.addChild(backButton)
        buttonNode.addChild(applyButton)
    }
    
    private func presentGrid() {
        if let grid = Grid(blockSize: mainBoard.size.width / 3.5, rows: 3, columns: 3) {
            grid.position = CGPoint (x: mainBoard.frame.midX, y: mainBoard.frame.midY)
            grid.zPosition = -8
            addChild(grid)
            
            var currentSkin = ImageName.PresentScene.SkinPrice.Present_1
            
            for row in 0...2 {
                for column in 0...2 {
                    let price = SKSpriteNode(imageNamed: currentSkin.description)
                    price.size =  CGSize(width: mainBoard.size.width / 3.8, height: mainBoard.size.width / 3.8)
                    price.name = currentSkin.description
                    price.position = grid.gridPosition(row: row, column: column)
                    price.zPosition = 1
                    currentSkin = currentSkin.next
                    grid.addChild(price)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var pos:CGPoint!
        for touch in touches{
            pos = touch.location(in: self)
        }
        
        switch state {
        case .Select:
            for c in nodes(at: pos){
                if c.name == PresentSceneButton.BackButton.rawValue {
                    backButtonPressed()
                } else if c.name == ImageName.PresentScene.SkinPrice.Present_1.description {
                    fadeAndChoose(present: .Present_1)
                } else if c.name == ImageName.PresentScene.SkinPrice.Present_2.description {
                    fadeAndChoose(present: .Present_2)
                } else if c.name == ImageName.PresentScene.SkinPrice.Present_3.description {
                    fadeAndChoose(present: .Present_3)
                } else if c.name == ImageName.PresentScene.SkinPrice.Present_4.description {
                    fadeAndChoose(present: .Present_4)
                } else if c.name == ImageName.PresentScene.SkinPrice.Present_5.description {
                    fadeAndChoose(present: .Present_5)
                } else if c.name == ImageName.PresentScene.SkinPrice.Present_6.description {
                    fadeAndChoose(present: .Present_6)
                } else if c.name == ImageName.PresentScene.SkinPrice.Present_7.description {
                    fadeAndChoose(present: .Present_7)
                } else if c.name == ImageName.PresentScene.SkinPrice.Present_8.description {
                    fadeAndChoose(present: .Present_8)
                } else if c.name == ImageName.PresentScene.SkinPrice.Present_9.description {
                    fadeAndChoose(present: .Present_9)
                } else if c.name == PresentSceneButton.ApplyButton.rawValue {
                    savePresentNumber()
                }
            }
        }
    }
    
    private func backButtonPressed(){
        self.recursiveRemovingSKActions(sknodes: self.children)
        self.removeAllChildren()
        self.removeAllActions()
        sceneManager.mainScene = nil
        let newScene = MainScene(size: self.size)
        self.view?.presentScene(newScene)
    }
    
    private func fadeAndChoose(present: ImageName.PresentScene.SkinPrice) {
        presentNumber = present.rawValue
        let fadeScreen = SKSpriteNode()
        fadeScreen.name = "FadeScreen\(present.description)"
        fadeScreen.zPosition = 50
        fadeScreen.position =  CGPoint(x: 0, y: 0)
        fadeScreen.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        fadeScreen.size = CGSize(width: 1, height: 1)
        fadeScreen.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let rect = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.PresentScene.presentSceneRays))
        rect.name = "Rect\(present.description)"
        rect.zPosition = 55
        rect.position =  CGPoint(x: frame.midX, y: frame.midY)
        rect.size = CGSize(width: 50, height: 50)
        
        let avatar = SKSpriteNode(texture: SKTexture(imageNamed: present.description))
        avatar.name = present.description
        avatar.zPosition = 100
        avatar.position =  CGPoint(x: frame.midX, y: frame.midY)
        avatar.size = CGSize(width: 50, height: 50)
        
        let scaleXFadeScreen = SKAction.scaleX(to: screenSize.width, duration: 0.05)
        let scaleYFadeScreen = SKAction.scaleY(to: screenSize.height, duration: 0.05)
        let fadeInFadeScreen = SKAction.fadeIn(withDuration: 3)
        let fadeOutFadeScreen = SKAction.fadeOut(withDuration: 6)
        let sequenceFadeScreen = SKAction.sequence([scaleXFadeScreen, scaleYFadeScreen, fadeInFadeScreen, fadeOutFadeScreen])
        self.addChild(fadeScreen)
        fadeScreen.run(sequenceFadeScreen)
        
        let scaleX = SKAction.scaleX(to: 6.95, duration: 0.15)
        let scaleY = SKAction.scaleY(to: 6.95, duration: 0.25)
        let fadeIn = SKAction.fadeIn(withDuration: 2)
        let fadeOut = SKAction.fadeOut(withDuration: 5)
        let sequence = SKAction.sequence([scaleX, scaleY, fadeIn, fadeOut])
        self.addChild(rect)
        rect.run(sequence)
        
        let scaleXAvatar = SKAction.resize(toWidth: screenSize.width / 2, duration: 0.1)
        let scaleYAvatar = SKAction.resize(toHeight: screenSize.width / 2, duration: 0.2)
        let fadeInAvatar = SKAction.fadeIn(withDuration: 1.5)
        let fadeOutAvatar = SKAction.fadeOut(withDuration: 4)
        let sequenceAvatar = SKAction.sequence([scaleXAvatar, scaleYAvatar, fadeInAvatar, fadeOutAvatar])
        self.addChild(avatar)
        avatar.run(sequenceAvatar)
        
        delay(bySeconds: 10) {
            let fadeScreenToRemove = self.childNode(withName: "FadeScreen\(present.description)")
            fadeScreenToRemove?.removeFromParent()
            
            let rectToRemove = self.childNode(withName: "Rect\(present.description)")
            rectToRemove?.removeFromParent()
            
            let avatarToRemove = self.childNode(withName: "\(present.description)")
            avatarToRemove?.removeFromParent()
        }
    }
    
    private func savePresentNumber() {
        gameManager.setupPresent(number: presentNumber)
        print(#line, presentNumber)
    }
}
