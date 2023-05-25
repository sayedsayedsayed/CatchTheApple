//
//  ContentView.swift
//  CatchTheApple
//
//  Created by Sayed Zulfikar on 25/05/23.
//

import SwiftUI
import SpriteKit
import GameKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    var collisionSound: AVAudioPlayer?
    var basketSound: AVAudioPlayer?
    var appleSound: AVAudioPlayer?
    
    let background = SKSpriteNode(imageNamed: "treeBg")
    var farmer = SKSpriteNode()
    var basket = SKSpriteNode()
    var monkey = SKSpriteNode()
    var apple = SKSpriteNode()
    var soil = SKSpriteNode()
    var spear = SKSpriteNode()
    var monkeyBar = SKSpriteNode()
    
    var draggableNode: SKSpriteNode?
    private var initialPosition: CGPoint = .zero
    private var canMove = false
    var speedFactor: Double = 1.0
    
    var appleTimer = Timer()
    
    @Published var gameOver = false
    @Published var gameComplete = false
    
    var score = 3
    var scoreLabel = SKLabelNode()
    var spearLabel = SKLabelNode()
    var monkeyLive = 10
    
    struct CBitMask {
        static let monkey: UInt32 = 0b1 //1
        static let apple: UInt32 = 0b10 //2
        static let farmer: UInt32 = 0b100 //4
        static let basket: UInt32 = 0b1000 //8
        static let soil: UInt32 = 0b10000 //8
        static let spear: UInt32 = 0b100000 //8
        
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        scene?.size = CGSize(width: 393, height: 852)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        
        background.zPosition = 1
        
        addChild(background)
        
        if let soundFileURL = Bundle.main.url(forResource: "gunshot", withExtension: "mp3") {
            do {
                collisionSound = try AVAudioPlayer(contentsOf: soundFileURL)
                collisionSound?.prepareToPlay()
            } catch {
                print("Error loading collision sound: \(error)")
            }
        }
        
        if let soundFileURL2 = Bundle.main.url(forResource: "kaching2", withExtension: "mp3") {
            do {
                basketSound = try AVAudioPlayer(contentsOf: soundFileURL2)
                basketSound?.prepareToPlay()
            } catch {
                print("Error loading collision sound: \(error)")
            }
        }
        
        if let soundFileURL3 = Bundle.main.url(forResource: "splat", withExtension: "mp3") {
            do {
                appleSound = try AVAudioPlayer(contentsOf: soundFileURL3)
                appleSound?.prepareToPlay()
            } catch {
                print("Error loading collision sound: \(error)")
            }
        }
        
        makeSoil()
        makeFarmer()
        makeBasket()
        makeMonkey()
        makeMonkeyBar()
        
        appleTimer = .scheduledTimer(timeInterval: 2 * speedFactor, target: self, selector: #selector(appleFunc), userInfo: nil, repeats: true)
        
        spearLabel.text = "Spear available"
        spearLabel.fontName = "Chalkduster"
        spearLabel.fontSize = 12
        spearLabel.fontColor = .blue
        spearLabel.zPosition = 10
        spearLabel.position = CGPoint(x: 60, y: size.height - 50)
        
        addChild(spearLabel)
        
        scoreLabel.text = "\(score)"
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = .black
        scoreLabel.zPosition = 10
        scoreLabel.position = CGPoint(x: 50, y: size.height - 85)
        
        addChild(scoreLabel)
        
        draggableNode = farmer
    }
    
    func makeMonkeyBar() {
        let barType = "monkeyBar\(monkeyLive)"
        
        monkeyBar.removeFromParent()
        
        monkeyBar = .init(imageNamed: barType)
        monkeyBar.setScale(0.075)
        monkeyBar.position = CGPoint(x: size.width - 60, y: size.height - 50)
        monkeyBar.zPosition = 10
        
        addChild(monkeyBar)
    }
    
    func makeMonkey(){
        
        let scale: CGFloat = 0.15
        monkey = .init(imageNamed: "monkey")
        
        monkey.setScale(scale)
        monkey.position = CGPoint(x: size.width/2, y: size.height - monkey.size.height/2)
        monkey.zPosition = 10
        
        let scaledSize = CGSize(width: monkey.size.width * scale, height: monkey.size.height)
        
        monkey.physicsBody = SKPhysicsBody(rectangleOf: scaledSize)
        monkey.physicsBody?.affectedByGravity = false
        monkey.physicsBody?.isDynamic = true
        monkey.physicsBody?.categoryBitMask = CBitMask.monkey
        monkey.physicsBody?.contactTestBitMask = CBitMask.spear
        monkey.physicsBody?.collisionBitMask = CBitMask.spear
        
        addChild(monkey)
        
        startRandomMovement()
    }
    
    func makeNewMonkey(pos: CGPoint){
        var newMonkey = SKSpriteNode()
        newMonkey = .init(imageNamed: "monkey")
        
        newMonkey.setScale(0.15)
        newMonkey.position = pos
        newMonkey.zPosition = 10
        
        let move1 = SKAction.fadeOut(withDuration: 0.2)
        let move2 = SKAction.fadeIn(withDuration: 0.2)
        
        let action = SKAction.repeat(SKAction.sequence([move1, move2]), count: 10)
        
        let sequence = SKAction.sequence([action])
        
        newMonkey.run(sequence)
        
        addChild(newMonkey)
        
    }
    
    func makeNewFarmer(pos: CGPoint){
        var newFarmer = SKSpriteNode()
        newFarmer = .init(imageNamed: "farmer")
        
        newFarmer.setScale(0.25)
        newFarmer.position = pos
        newFarmer.zPosition = 10
        
        let move1 = SKAction.fadeOut(withDuration: 0.2)
        let move2 = SKAction.fadeIn(withDuration: 0.2)
        
        let action = SKAction.repeat(SKAction.sequence([move1, move2]), count: 10)
        
        let sequence = SKAction.sequence([action])
        
        newFarmer.run(sequence)
        
        addChild(newFarmer)
        
    }
    
    
    private func startRandomMovement() {
        let duration: TimeInterval = 1.0 * speedFactor // Duration for each movement
        
        // Create an action sequence to move the sprite randomly
        let moveAction = SKAction.sequence([
            SKAction.run { [weak self] in
                self?.moveSpriteToRandomPosition()
            },
            SKAction.wait(forDuration: duration)
        ])
        
        // Repeat the action sequence forever
        let repeatAction = SKAction.repeatForever(moveAction)
        
        // Run the action on the sprite
        monkey.run(repeatAction)
    }
    
    private func moveSpriteToRandomPosition() {
        let minX: CGFloat = 0
        let maxX: CGFloat = size.width
        let minY: CGFloat = size.height/2
        let maxY: CGFloat = size.height - monkey.size.height/2
        
        // Generate random x and y coordinates within the specified range
        let randomX = CGFloat.random(in: minX...maxX)
        let randomY = CGFloat.random(in: minY...maxY)
        
        // Create an action to move the sprite to the random position
        let moveAction = SKAction.move(to: CGPoint(x: randomX, y: randomY), duration: 1 * speedFactor)
        
        // Run the action on the sprite
        monkey.run(moveAction)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA : SKPhysicsBody
        let contactB : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            contactA = contact.bodyA
            contactB = contact.bodyB
        }
        else{
            contactA = contact.bodyB
            contactB = contact.bodyA
        }
        
        //apple hit farmer
        if contactA.categoryBitMask == CBitMask.apple && contactB.categoryBitMask == CBitMask.farmer{
            
            updateScore(add: false)
            updateMonkeyLive(add: true)
            
            let explo = SKEmitterNode(fileNamed: "fire2")
            explo?.position = contactA.node!.position
            explo?.zPosition = 5
            addChild(explo!)
            
            appleSound?.play()
            contactA.node?.removeFromParent()
        }
        
        //apple hit basket
        if contactA.categoryBitMask == CBitMask.apple && contactB.categoryBitMask == CBitMask.basket{
            
            updateScore(add: true)
            
            basketSound?.play()
            
            contactA.node?.removeFromParent()
        }
        
        //spear hit monkey
        if contactA.categoryBitMask == CBitMask.monkey && contactB.categoryBitMask == CBitMask.spear{
            
            updateMonkeyLive(add: false)
            
            let explo = SKEmitterNode(fileNamed: "fire")
            explo?.position = contactA.node!.position
            explo?.zPosition = 5
            addChild(explo!)
            collisionSound?.play()
            
            contactB.node?.removeFromParent()
        }
        
        //spear hit apple
        if contactA.categoryBitMask == CBitMask.apple && contactB.categoryBitMask == CBitMask.spear{
            
            let explo = SKEmitterNode(fileNamed: "fire")
            explo?.position = contactA.node!.position
            explo?.zPosition = 5
            addChild(explo!)
            
            collisionSound?.play()
            
            contactB.node?.removeFromParent()
            contactA.node?.removeFromParent()
        }
    }
    
    func makeSoil(){
        soil = .init(imageNamed: "soil")
        soil.position = CGPoint(x: size.width, y: 20)
        soil.zPosition = 10
        
        addChild(soil)
    }
    
    func makeFarmer(){
        let scale: CGFloat = 0.25
        
        farmer = .init(imageNamed: "farmer")
        farmer.setScale(scale)
        farmer.position = CGPoint(x: size.width/2, y: farmer.size.height/2)
        farmer.zPosition = 10
        
        let scaledSize = CGSize(width: farmer.size.width * scale, height: farmer.size.height)
        
        farmer.physicsBody = SKPhysicsBody(rectangleOf: scaledSize)
        farmer.physicsBody?.affectedByGravity = false
        farmer.physicsBody?.isDynamic = true
        farmer.physicsBody?.categoryBitMask = CBitMask.farmer
        farmer.physicsBody?.contactTestBitMask = CBitMask.apple
        farmer.physicsBody?.collisionBitMask = CBitMask.apple
        
        addChild(farmer)
    }
    
    func makeBasket(){
        let scale: CGFloat = 0.075
        
        basket = .init(imageNamed: "basket")
        basket.setScale(scale)
        basket.position = CGPoint(x: size.width/2 - farmer.size.width/3, y: farmer.size.height/2)
        basket.zPosition = 10
        
        basket.physicsBody = SKPhysicsBody(rectangleOf: basket.size)
        basket.physicsBody?.affectedByGravity = false
        basket.physicsBody?.isDynamic = true
        basket.physicsBody?.categoryBitMask = CBitMask.basket
        basket.physicsBody?.contactTestBitMask = CBitMask.apple
        farmer.physicsBody?.collisionBitMask = CBitMask.apple
        
        addChild(basket)
    }
    
    
    @objc func appleFunc() {
        let scale: CGFloat = 0.05
        apple = .init(imageNamed: "apple")
        apple.position = monkey.position
        apple.zPosition = 3
        apple.setScale(scale)
        
        apple.physicsBody = SKPhysicsBody(rectangleOf: apple.size)
        apple.physicsBody?.affectedByGravity = false
        apple.physicsBody?.categoryBitMask = CBitMask.apple
        apple.physicsBody?.contactTestBitMask = CBitMask.farmer | CBitMask.spear
        apple.physicsBody?.collisionBitMask = CBitMask.farmer | CBitMask.spear
        
        let move1 = SKAction.moveTo(y: 0 - monkey.size.height, duration: 1.5 * speedFactor)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move1, removeAction])
        apple.run(sequence)
        
        addChild(apple)
    }
    
    func updateMonkeyLive(add: Bool) {
        if !add && monkeyLive > 0 {
            monkeyLive -= 1
            
        }
        else if add && monkeyLive < 10 {
            monkeyLive += 1
        }
        
        makeMonkeyBar()
        
        if monkeyLive < 5 {
            speedFactor = 0.5
        }
        else {
            speedFactor = 1.0
        }
        
        if monkeyLive == 0 {
            gameCompleteFunc()
        }
        
        
    }
    
    func updateScore(add: Bool) {
        if add && score < 10 {
            score += 1
        }
        else if !add {
            score -= 1
        }
        
        
        if score < 0 {
            //game over
            gameOverFunc()
        }
        
        scoreLabel.text = "\(score)"
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let node = draggableNode {
            let touchLocation = touch.location(in: self)
            
            if canMove {
                // Calculate the distance moved
                let deltaX = touchLocation.x - initialPosition.x
                
                // Update the position of the draggable node
                node.position.x = initialPosition.x + deltaX
                basket.position.x = node.position.x - farmer.size.width/3
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Check if a touch is on the draggable node
        if let touch = touches.first, let node = draggableNode {
            let touchLocation = touch.location(in: self)
            
            // Check if the touch is on the draggable node
            if node.contains(touchLocation) {
                initialPosition = node.position
                canMove = true
            }
            else {
                canMove = false
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Reset the initial position when the touch ends
        initialPosition = .zero
        shootSpear()
    }
    
    private func shootSpear() {
        if score > 0 {
            
            let scale: CGFloat = 0.1
            
            spear = .init(imageNamed: "spear")
            spear.position.y = farmer.position.y
            spear.position.x = farmer.position.x + 50
            spear.zPosition = 3
            spear.setScale(scale)
            
            let scaledSize = CGSize(width: spear.size.width * scale, height: spear.size.height)
            
            spear.physicsBody = SKPhysicsBody(rectangleOf: scaledSize)
            spear.physicsBody?.affectedByGravity = false
            spear.physicsBody?.isDynamic = true
            spear.physicsBody?.categoryBitMask = CBitMask.spear
            spear.physicsBody?.contactTestBitMask = CBitMask.monkey | CBitMask.apple
            spear.physicsBody?.collisionBitMask = CBitMask.monkey | CBitMask.apple
            addChild(spear)
            
            let moveAction = SKAction.moveTo(y: size.height, duration: 1)
            let deleteAction = SKAction.removeFromParent()
            let combine = SKAction.sequence([moveAction, deleteAction])
            
            spear.run(combine)
            
            updateScore(add: false)
        }
    }
    
    func gameCompleteFunc(){
        SoundManager.instance.StopBGSound()
        let delayAction = SKAction.wait(forDuration: 5.0)
        
        appleTimer.invalidate()
        monkey.removeFromParent()
        makeNewMonkey(pos: monkey.position)
        
        let updateAction = SKAction.run {
            // Update your variable here
            self.removeAllChildren()
            self.gameComplete = true
        }
        
        let sequenceAction = SKAction.sequence([delayAction, updateAction])
        
        // Run the sequence action on a node
        let node = SKNode()
        node.run(sequenceAction)
        
        // Add the node to the scene
        addChild(node)
        
    }
    
    func gameOverFunc(){
        SoundManager.instance.StopBGSound()
        let delayAction = SKAction.wait(forDuration: 5.0)
        
        appleTimer.invalidate()
        farmer.removeFromParent()
        basket.removeFromParent()
        makeNewFarmer(pos: farmer.position)
        
        let updateAction = SKAction.run {
            // Update your variable here
            self.removeAllChildren()
            self.gameOver = true
        }
        
        let sequenceAction = SKAction.sequence([delayAction, updateAction])
        
        // Run the sequence action on a node
        let node = SKNode()
        node.run(sequenceAction)
        
        // Add the node to the scene
        addChild(node)
        
    }
}

struct ContentView: View {
    @ObservedObject var scene = GameScene()
    
    var body: some View {
        NavigationView{
            HStack{
                ZStack{
                    SpriteView(scene: scene)
                        .ignoresSafeArea()
                    
                    if scene.gameOver == true {
                        GameOverView()
                    }
                    else if scene.gameComplete == true {
                        FinishView()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
