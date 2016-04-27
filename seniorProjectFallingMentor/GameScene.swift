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
    let moveFactor = 1.05
    var now : NSDate?
    var nextTime : NSDate?
    var gameOverLabel : SKLabelNode?
    var healthLabel : SKLabelNode?
    

    override func didMoveToView(view: SKView) {
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
        healthLabel?.position = CGPoint(x:CGRectGetMinX(self.frame) + 80, y:(CGRectGetMinY(self.frame) + 100));
        
        self.addChild(healthLabel!)
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
            let newX = Int(arc4random()%1024)
            let newY = Int(self.frame.height+10)
            let p = CGPoint(x:newX,y:newY)
            let destination =  CGPoint(x:newX, y:0.0)
            
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
        let sprite = SKSpriteNode(imageNamed:"Matt Legrand")
        sprite.name = "Destroyable"
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        sprite.position = p
        
        let duration = NSTimeInterval(moverSpeed)
        let action = SKAction.moveTo(destination, duration: duration)
        sprite.runAction(SKAction.repeatActionForever(action))
        
        let rotationAction = SKAction.rotateToAngle(CGFloat(3.142), duration: 0)
        sprite.runAction(SKAction.repeatAction(rotationAction, count: 0))
        
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
                    score+=1
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