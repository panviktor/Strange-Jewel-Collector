//
//  LevelSelectorScene.swift
//  Strange Jewel Collector
//
//  Created by Viktor on 18.08.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import SpriteKit

class LevelSelectorScene: SKScene {
    private enum State {
        case Select
    }
    
    private enum LevelSelectorScene: String {
        case BackButton
    }
    
    private let settingsNode = SKSpriteNode()
    private var state: State = .Select
    private let screenSize: CGRect = UIScreen.main.bounds
    private let audioVibroManager = AudioVibroManager.shared
    private let sceneManager = SceneManager.shared
    private var gameTableView = GameLevelTableView()
    private var label: SKLabelNode?
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        loadBackground()
        // Table setup
        gameTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        gameTableView.frame = CGRect(x:20,y:50,width:280,height:200)
        self.scene?.view?.addSubview(gameTableView)
        gameTableView.reloadData()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var pos:CGPoint!
        for touch in touches{
            pos = touch.location(in: self)
        }
        
        switch state {
        case .Select:
            for c in nodes(at: pos){
                if c.name == LevelSelectorScene.BackButton.rawValue {
                    backButtonPressed()
                }
            }
        }
    }
    
    private func loadBackground() {
        let loadBackground = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.gameSceneSettingsBackground))
        loadBackground.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        loadBackground.size = CGSize(width: screenSize.width, height: screenSize.height)
        loadBackground.zPosition = -10
        self.addChild(loadBackground)
    }
    
    private func backButtonPressed(){
        self.recursiveRemovingSKActions(sknodes: self.children)
        self.removeAllChildren()
        self.removeAllActions()
        sceneManager.mainScene = nil
        let newScene = MainScene(size: self.size)
        self.view?.presentScene(newScene)
    }
}
