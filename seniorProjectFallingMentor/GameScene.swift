//
//  GameScene.swift
//  seniorProjectFallingMentor
//
//  Created by Jay on 4/26/16.
//  Copyright (c) 2016 JayTreZ. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var score = 0
    var health = 5
    var gameOver : Bool?
    let maxNumberOfMentors = 10
    var currentNumberOfMentors : Int?
    var timeBetweenMentors : Double?
    var moverSpeed = 5.0
    let moveFactor = 1.02
    var now : NSDate?
    var nextTime : NSDate?
    var gameOverLabel : SKLabelNode?
    var healthLabel : SKLabelNode?
    var scoreLabel : SKLabelNode?

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view);
        initializeValues()
    }
    
    /*
     Sets the values for our variables.
     */
    func initializeValues(){
        self.removeAllChildren()
        
        score = 0
        gameOver = false
        currentNumberOfMentors = 0
        timeBetweenMentors = 1.0
        moverSpeed = 5.0
        health = 5
        nextTime = NSDate()
        now = NSDate()
        
        healthLabel = SKLabelNode(fontNamed:"System")
        healthLabel?.text = "Health: \(health)"
        healthLabel?.fontSize = 30
        healthLabel?.fontColor = SKColor.blackColor()
        healthLabel?.position = CGPoint(x: 70, y: 10);
        self.addChild(healthLabel!)
        
        
        scoreLabel = SKLabelNode(fontNamed:"System")
        scoreLabel?.text = "Score: \(score)"
        scoreLabel?.fontSize = 30
        scoreLabel?.fontColor = SKColor.blackColor()
        scoreLabel?.position = CGPoint(x: 300, y: 10);
        self.addChild(scoreLabel!)
    }
    
    /*
     Called before each frame is rendered
     */
    override func update(currentTime: CFTimeInterval) {
        
        healthLabel?.text="Health: \(health)"
        if(health <= 3){
            healthLabel?.fontColor = SKColor.redColor()
        }
        
        now = NSDate()
        if (currentNumberOfMentors < maxNumberOfMentors &&
            now?.timeIntervalSince1970 > nextTime?.timeIntervalSince1970 &&
            health > 0){
            
            nextTime = now?.dateByAddingTimeInterval(NSTimeInterval(timeBetweenMentors!))
            let randomXValue = Int(arc4random()%UInt32(self.frame.width))
            
            let bottomOfTheScreenY = Int(self.frame.height+10)
            
            let p = CGPoint(x:randomXValue, y:bottomOfTheScreenY)
            
            let destination =  CGPoint(x:randomXValue, y: 0)
            
            createMentor(p, destination: destination)
            
            moverSpeed = moverSpeed/moveFactor
            timeBetweenMentors = timeBetweenMentors!/moveFactor
        }
        checkIfMentorsReachTheBottom()
        checkIfGameIsOver()
    }
    
    /*
     Creates a ship
     Rotates it 90º
     Adds a mover to it go downwards
     Adds the ship to the scene
     */
    func createMentor(p:CGPoint, destination:CGPoint) {
        let sprite = SKSpriteNode(imageNamed:"matt")
        sprite.name = "Destroyable"
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        sprite.position = p
        
        let duration = NSTimeInterval(moverSpeed)
        
        let action = SKAction.moveTo(destination, duration: duration)
        sprite.runAction(SKAction.repeatActionForever(action))      
        currentNumberOfMentors?+=1
        self.addChild(sprite)
    }
    
    /*
     When someone first touches
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            if let theName = self.nodeAtPoint(location).name {
                if theName == "Destroyable" {
                    self.removeChildrenInArray([self.nodeAtPoint(location)])
                    currentNumberOfMentors?-=1
                    score = score+1
                    scoreLabel?.text = "Score: \(score)"
                }
            }
            if (gameOver==true){
                initializeValues()
            }
        }
    }
    
    /*
     Check if the game is over by looking at our health
     Shows game over screen if needed
     */
    func checkIfGameIsOver(){
        if (health <= 0 && gameOver == false){
            self.removeAllChildren()
            showGameOverScreen()
            gameOver = true
        }
    }
    
    /*
     Checks if an enemy ship reaches the bottom of our screen
     */
    func checkIfMentorsReachTheBottom(){
        for child in self.children {
            if(child.position.y == 0){
                self.removeChildrenInArray([child])
                currentNumberOfMentors?-=1
                health -= 1
            }
        }
    }
    
    /*
     Displays the actual game over screen
     */
    func showGameOverScreen(){
        gameOverLabel = SKLabelNode(fontNamed:"System")
        gameOverLabel?.text = "Game Over! Score: \(score)"
        gameOverLabel?.fontColor = SKColor.redColor()
        gameOverLabel?.fontSize = 65;
        gameOverLabel?.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(gameOverLabel!)
    }
}