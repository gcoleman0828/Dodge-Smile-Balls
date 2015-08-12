//
//  GameScene.swift
//  Dodge Balls
//
//  Created by GreggColeman on 8/10/15.
//  Copyright (c) 2015 Gregg Coleman. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var hero:Hero!
    var touchLocation = CGFloat()
    var gameOver = false
    var badGuys:[BadGuy] = []
    var endOfScreenRight = CGFloat()
    var endOfScreenLeft = CGFloat()
    
    override func didMoveToView(view: SKView) {
        endOfScreenLeft = (self.size.width / 2) * CGFloat(-1)
        endOfScreenRight = self.size.width / 2
        
        addBG()
        addJeff()
        addBadGuys()
    }
    
    
    func addBG(){
        let bg = SKSpriteNode(imageNamed:"bg")
        scene?.addChild(bg)
    }
    
    func addJeff(){
        let jeff = SKSpriteNode(imageNamed: "jeff")
        hero = Hero(guy:jeff)
        scene?.addChild(jeff)
    }
    
    /* Creates the concrete bad guy using the generic addBadGuy method */
    func addBadGuys(){
        addBadGuy(named:"natasha", speed:1.0, yPos:CGFloat (self.size.height/4))
        addBadGuy(named:"paul", speed:1.5, yPos:CGFloat(0))
    }
    
    // Creates the bad guy based on the string "named" image and 
    // adds it to the scene. Also resets the bad guys positioning
    // and adds the bad guy to an array to keep track after creation
    func addBadGuy(#named:String, speed:Float, yPos:CGFloat){
        var badGuyNode = SKSpriteNode(imageNamed: named)
        
        var badGuy = BadGuy(speed: speed, guy: badGuyNode)
        badGuy.yPos = badGuyNode.position.y
        
        badGuys.append(badGuy)
        resetBadGuy(badGuyNode, yPos: yPos)
        addChild(badGuyNode)
        
    }
    
    func resetBadGuy(badGuyNode:SKSpriteNode, yPos:CGFloat){
        badGuyNode.position.x = endOfScreenRight
        badGuyNode.position.y = yPos
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
     
        for touch in (touches as! Set<UITouch>) {
            if(!gameOver){
                var screenSize = (self.size.height / 2)
                // Set the location was touched to the screen size plus the invert of y
                // we invert to a negative so that the ball will go in the correct location
                // BECAUSE WE ARE ADDING TO THE SCREEN SIZE, A NEGATIVE WILL MAKE IT GO THE CORRECT DIRECTION
                touchLocation = (touch.locationInView(self.view).y * -1) + screenSize
            }
        }
        
        let moveAction = SKAction.moveToY(touchLocation, duration: 0.5)
        moveAction.timingMode = SKActionTimingMode.EaseOut
        hero.guy.runAction(moveAction){
            // trailing closure
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if !gameOver{
            updateBadGuysPosition()
        }
        
    }
    
    func updateBadGuysPosition(){
        
        for badGuy in badGuys{
            if !badGuy.moving{
                badGuy.currentFrame++
                if badGuy.currentFrame > badGuy.randomFrame{
                    badGuy.moving = true
                }
            }
                else{
                    // If we haven't reached the random frame, we can still move forward.
                    // This line creates the sin wave approach for the little guys
                    badGuy.guy.position.y = CGFloat(Double(badGuy.guy.position.y) + sin(badGuy.angle) * badGuy.range)
                    // Each time through, the angle will get bigger along with the sin wave
                    badGuy.angle += hero.speed
                    
                    // If the bad guy is at the end of the screen, reset it to the negative so
                    // it starts back from the right
                    if badGuy.guy.position.x > endOfScreenLeft{
                       
                        badGuy.guy.position.x -= CGFloat(badGuy.speed)
                        
                    }else {
                        badGuy.guy.position.x = endOfScreenRight
                        badGuy.currentFrame = 0
                        badGuy.setRandomFrame()
                        badGuy.moving  = false
                        badGuy.range += 0.1
                        updateScore()
                    }
                }
            }
        }
    
    func updateScore(){
        
    }
    
    
}
