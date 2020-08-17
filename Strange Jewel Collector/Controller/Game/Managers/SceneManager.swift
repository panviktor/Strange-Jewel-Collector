//
//  SceneManager.swift
//  Wolf Treasure Adventure
//
//  Created by Viktor on 27.07.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

final class SceneManager {
    static let shared = SceneManager()
    var mainScene: MainScene?
    var gameScene: GameScene?
    fileprivate init() {}
}
