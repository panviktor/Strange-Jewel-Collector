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
        
        case LevelScene
        case GameSettingsScene
        case PresentScene
        case TopScoreScene
    }
    
    private enum MainSceneButton: String {
        case PlayButton
        case LevelSceneButton
        case SettingsButton
        case PresentButton
        case ScoreButton
    }
    
    private let sceneManager = SceneManager.shared
    private let audioVibroManager = AudioVibroManager.shared
    private let screenSize: CGRect = UIScreen.main.bounds
    
    typealias ShaderExample = (title: String, shader: SKShader)
    private var shaders = [ShaderExample]()
    
    override func didMove(to view: SKView) {
        guard sceneManager.mainScene == nil else { return }
        sceneManager.mainScene = self
        removeUIViews()
        shaders.append(("Water", SKShader.createWaterShader()))
        shaders.append(("Color", SKShader.createLightGrid()))
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
        mainSceneBackground.shader = shaders[0].shader
        self.addChild(mainSceneBackground)
        
        let cloud = SKSpriteNode()
        cloud.texture = SKTexture(imageNamed: ImageName.mainSceneCloud)
        cloud.position = CGPoint(x: screenSize.width/2, y: screenSize.height * 0.60)
        cloud.size = CGSize(width: screenSize.width, height: screenSize.height * 3 / 4)
        cloud.zPosition = -9
        cloud.name = ImageName.mainSceneCloud
        cloud.alpha = 0.8
        cloud.shader = shaders[0].shader
        self.addChild(cloud)
        
        let root = SKSpriteNode()
        root.color = .clear
        root.name = "RootSKSpriteNode"
        root.size = CGSize(width: screenSize.width, height: screenSize.height)
        root.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        root.position = CGPoint(x: 0, y:  0)
        
        root.zPosition = -7
        self.addChild(root)
        
        let playButton = createUIButton(name: MainSceneButton.PlayButton, offsetPosX: screenSize.width / 2,
                                        offsetPosY: screenSize.height * 0.80)
//        playButton.shader = shaders[1].shader
        root.addChild(playButton)
        
        let levelButton = createUIButton(name: MainSceneButton.LevelSceneButton, offsetPosX: screenSize.width / 2,
                                         offsetPosY: screenSize.height * 0.65)
//        levelButton.shader = shaders[1].shader
        root.addChild(levelButton)
        
        let settingsButton = createUIButton(name: MainSceneButton.SettingsButton, offsetPosX: screenSize.width / 2,
                                            offsetPosY: screenSize.height * 0.50)
//        settingsButton.shader = shaders[1].shader
        root.addChild(settingsButton)
        
        let scoreButton = createUIButton(name: MainSceneButton.ScoreButton, offsetPosX: screenSize.width / 2,
                                         offsetPosY: screenSize.height * 0.35)
//        scoreButton.shader = shaders[1].shader
        root.addChild(scoreButton)
        
        //FIXME: - add this button, when PriceMenu was refactoring
        //        let priceButton = createUIButton(name: MainSceneButton.PresentButton, offsetPosX: screenSize.width / 2,
        //                                         offsetPosY: screenSize.height * 0.25)
        //        root.addChild(priceButton)
        
        cloud.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 0, y: 28, duration: 2.5),
                                                            SKAction.moveBy(x: 0, y: -28, duration: 2.5)])))
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
            } else if c.name == MainSceneButton.LevelSceneButton.rawValue {
                prepareToChangeScene(scene: .LevelScene)
            } else if c.name == MainSceneButton.SettingsButton.rawValue {
                prepareToChangeScene(scene: .GameSettingsScene)
            } else if c.name == MainSceneButton.PresentButton.rawValue {
                prepareToChangeScene(scene: .PresentScene)
            } else if c.name == MainSceneButton.ScoreButton.rawValue {
                prepareToChangeScene(scene: .TopScoreScene)
            }
        }
    }
    
    private func createUIButton(name: MainSceneButton,
                                offsetPosX dx:CGFloat,
                                offsetPosY dy:CGFloat) -> SKSpriteNode {
        
        let button = SKSpriteNode()
        button.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        switch name {
        case .PlayButton:
            button.texture = SKTexture(imageNamed: ImageName.mainScenePlayButton)
        case .LevelSceneButton:
            button.texture = SKTexture(imageNamed: ImageName.mainSceneLevelButton)
        case .SettingsButton:
            button.texture = SKTexture(imageNamed: ImageName.mainSceneSettingsButton)
        case .ScoreButton:
            button.texture = SKTexture(imageNamed: ImageName.mainSceneScoreButton)
        case .PresentButton:
            button.texture = SKTexture(imageNamed: ImageName.mainSceneChoosePresentButton)
        }
        
        button.position = CGPoint(x: dx, y: dy)
        button.size = CGSize(width: screenSize.width / 2.5, height: screenSize.height / 8)
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
            removeSceneHelper()
            let newScene = GameScene(size: self.size)
            self.view?.presentScene(newScene)
        case .LevelScene:
            removeSceneHelper()
            let newScene = LevelSelectorScene(size: self.size)
            self.view?.presentScene(newScene)
        case .GameSettingsScene:
            removeSceneHelper()
            let newScene = GameSettingsScene(size: self.size)
            self.view?.presentScene(newScene)
        case .TopScoreScene:
            removeSceneHelper()
            let newScene = TopScoreScene(size: self.size)
            self.view?.presentScene(newScene)
        case .PresentScene:
            removeSceneHelper()
            let newScene = PresentScene(size: self.size)
            self.view?.presentScene(newScene)
        }
    }
    
    private func removeSceneHelper() {
        self.recursiveRemovingSKActions(sknodes: self.children)
        self.removeAllChildren()
        self.removeAllActions()
    }
    

}

extension SKShader {
    class func createWaterShader() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_speed", float: 3),
            SKUniform(name: "u_strength", float: 2.5),
            SKUniform(name: "u_frequency", float: 10)
        ]
        return SKShader(fromFile: "SHKWater", uniforms: uniforms)
    }
    
    class func createCircleWaveRainbowBlended() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_speed", float: 1),
            SKUniform(name: "u_brightness", float: 0.5),
            SKUniform(name: "u_strength", float: 2),
            SKUniform(name: "u_density", float: 100),
            SKUniform(name: "u_center", point: CGPoint(x: 0.68, y: 0.33)),
            SKUniform(name: "u_red", float: -1)
        ]
        
        return SKShader(fromFile: "SHKCircleWaveRainbowBlended", uniforms: uniforms)
    }
    
    class func createLightGrid() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_density", float: 8),
            SKUniform(name: "u_speed", float: 3),
            SKUniform(name: "u_group_size", float: 2),
            SKUniform(name: "u_brightness", float: 3),
        ]
        
        return SKShader(fromFile: "SHKLightGrid", uniforms: uniforms)
    }
}
