//
//  MainScene.swift
//  Wolf Treasure Adventure
//
//  Created by Viktor on 27.07.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import SpriteKit
import DeviceKit

class MainScene: SKScene, SKPhysicsContactDelegate {
    private enum Scene {
        case MainScene
        case GameScene
        
        case GameSettingsScene
        case TopScoreScene
    }
    
    private enum MainSceneButton: String {
        case PlayButton
        case SettingsButton
        case ScoreButton
    }
    
    private let sceneManager = SceneManager.shared
    private let audioVibroManager = AudioVibroManager.shared
    private let screenSize: CGRect = UIScreen.main.bounds
    
    override func didMove(to view: SKView) {
        guard sceneManager.mainScene == nil else { return }
        sceneManager.mainScene = self
        removeUIViews()
        // Setting up delegate for Physics World & Set up gravity
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        loadBackground()
        try? audioVibroManager.playMusic(type: .mainSceneBackground)
    }
    
    private func loadBackground(){
        let mainSceneBackground = SKSpriteNode()
        mainSceneBackground.texture = SKTexture(imageNamed: ImageName.mainSceneBackground)
        mainSceneBackground.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        mainSceneBackground.size = CGSize(width: screenSize.width, height: screenSize.height)
        mainSceneBackground.zPosition = -10
        mainSceneBackground.name = ImageName.mainSceneBackground
        self.addChild(mainSceneBackground)
        
        let cloud = SKSpriteNode()
        cloud.texture = SKTexture(imageNamed: ImageName.mainSceneCloud)
        cloud.position = CGPoint(x: screenSize.width/2, y: screenSize.height * 0.60)
        cloud.size = CGSize(width: screenSize.width, height: screenSize.height * 3 / 4)
        cloud.zPosition = -9
        cloud.name = ImageName.mainSceneCloud
        cloud.alpha = 0.8
        self.addChild(cloud)
        
        let root = SKSpriteNode()
        root.color = .clear
        root.name = "RootSKSpriteNode"
        root.size = CGSize(width: screenSize.width, height: screenSize.height * 0.7)
        root.position = CGPoint(x: screenSize.width / 2, y: screenSize.height / 1.5)
        root.zPosition = -7
        self.addChild(root)
        
        let bd_one_button = createUIButton(name: MainSceneButton.PlayButton, offsetPosX: 0, offsetPosY: 140)
        root.addChild(bd_one_button)
        
        let bd_two_button = createUIButton(name: MainSceneButton.SettingsButton, offsetPosX: 0, offsetPosY: 0)
        root.addChild(bd_two_button)
        
        let bd_three_button = createUIButton(name: MainSceneButton.ScoreButton, offsetPosX: 0, offsetPosY: -140)
        root.addChild(bd_three_button)
        
        cloud.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 0, y: 25, duration: 3),
                                                            SKAction.moveBy(x: 0, y: -25, duration: 3)])))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var pos: CGPoint!
        for touch in touches {
            pos = touch.location(in: self)
        }
        
        let childs = self.nodes(at: pos)
        for c in childs {
            if c.name == MainSceneButton.PlayButton.rawValue {
                prepareToChangeScene(scene: .GameScene)
            } else if c.name == MainSceneButton.SettingsButton.rawValue {
                prepareToChangeScene(scene: .GameSettingsScene)
            } else if c.name == MainSceneButton.ScoreButton.rawValue {
                prepareToChangeScene(scene: .TopScoreScene)
            }
        }
    }
    
    private func createUIButton(name: MainSceneButton,
                                offsetPosX dx:CGFloat,
                                offsetPosY dy:CGFloat) -> SKSpriteNode {
        
        let button = SKSpriteNode()
        button.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        switch name {
        case .PlayButton:
            button.texture = SKTexture(imageNamed: ImageName.mainScenePlayButton)
        case .SettingsButton:
            button.texture = SKTexture(imageNamed: ImageName.mainSceneSettingsButton)
        case .ScoreButton:
            button.texture = SKTexture(imageNamed: ImageName.mainSceneScoreButton)
        }
        
        button.position = CGPoint(x: dx, y: dy)
        button.size = CGSize(width: screenSize.width / 4.5, height: screenSize.height / 8)
        button.name = name.rawValue
        button.alpha = 0.85
        return button
    }
    
    private func prepareToChangeScene(scene: Scene) {
        switch scene {
        case .MainScene:
            debugPrint("Something go wrong?")
            break
        case .GameScene:
            self.recursiveRemovingSKActions(sknodes: self.children)
            self.removeAllChildren()
            self.removeAllActions()
            let newScene = GameScene(size: self.size)
            self.view?.presentScene(newScene)
        case .GameSettingsScene:
            self.recursiveRemovingSKActions(sknodes: self.children)
            self.removeAllChildren()
            self.removeAllActions()
            let newScene = GameSettingsScene(size: self.size)
            self.view?.presentScene(newScene)
        case .TopScoreScene:
            self.recursiveRemovingSKActions(sknodes: self.children)
            self.removeAllChildren()
            self.removeAllActions()
            let newScene = TopScoreScene(size: self.size)
            self.view?.presentScene(newScene)
        }
    }
}
