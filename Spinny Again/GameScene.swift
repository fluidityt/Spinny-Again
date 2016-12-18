//
//  GameScene.swift
//  Spinny Again
//
//  Created by Dude Guy on 12/14/16.
//  Copyright © 2016 Dude Guy. All rights reserved.
//

import SpriteKit
import GameplayKit

// MARK: - Props:

class GameScene: SKScene {

	// Actual mins:
	// 025 = 4  slow
	// 05  = 2	normal
	// .1  = 1	fast
	var sensitivity = (min: 0.0125, max: 0.845, cur: 0.2)
	var scaleFactor = CGFloat(7)

	var toucherCount = [0]
	var toucherSum = 0

	var lastFramesTime = TimeInterval()
	var dTime = TimeInterval()
	var firstrun = true
}


// MARK: - Funcs:

extension GameScene {

	func editorNodes() -> (number: SKLabelNode, slider: SKSpriteNode) {
		return (number: childNode(withName: "speed")!.childNode(withName: "number") as! SKLabelNode,
		        slider: childNode(withName: "accel slider") as! SKSpriteNode
		)
	}

 func clockwise() {
	childNode(withName: "base")!.zRotation -= CGFloat(sensitivity.cur)
	}
	func counterClockwise() {
		childNode(withName: "base")!.zRotation += CGFloat(sensitivity.cur)
	}
	
}

// MARK: - Overrides:
extension GameScene {

	override func didMove(to: SKView) {
		///**/ ball.run(.colorize(with: rightColor, colorBlendFactor: 1, duration: 0))

		func makeBalls() {
			// Iterations of our EditorNodes
			let colors = ["cyan", "yellow", "pink"];					/**/ for color in colors {
				let name = "ball" + " " + color;								/**/ let ball = childNode(name) as! SKSpriteNode
				let circle = SKShapeNode(circleOfRadius: 512);	/**/ circle.isAntialiased = true;
				circle.fillColor = ball.color;						  		/**/ ball.texture = view!.texture(from: circle)!
				// FIXME: set up physics body to bounding circle
				ball.texture!.usesMipmaps = true;								/**/ ball.setScale(0.5)
			}
		};	makeBalls()
		editorNodes().slider.isUserInteractionEnabled = true
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

	}

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

		func spinNode() {
					let x = abs(
			touches.first!.location(in: self).x
				- touches.first!.previousLocation(in: self).x
		)

		let y = x / frame.width
		var zz = y / CGFloat(dTime)
		zz/=scaleFactor

		let z = Double(zz)
		if z > sensitivity.max { sensitivity.cur = sensitivity.max }
		else if z < sensitivity.min { sensitivity.cur = sensitivity.min }
		else { sensitivity.cur = z }

			print(zz)
			print(sensitivity.cur)
			print("\n")
		toucherCount.append((1))
		toucherSum += Int(z)
			// print( toucherSum / toucherCount.count)

		touches.first!.location(in: self).x > touches.first!.previousLocation(in: self).x // Move right
			? clockwise()
			: counterClockwise()
		}; spinNode()
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		toucherCount = []
		toucherSum = 0
	}

	override func update(_ currentTime: TimeInterval) {

		if firstrun { lastFramesTime = currentTime; firstrun = false; return }
		dTime = currentTime - lastFramesTime
		lastFramesTime = currentTime
	}
}
		/*func makeLights() {
			// Bulb:

			let lightBulb = TouchMeSprite(color: .black, size: CGSize(width: 100, height: 100))
			// Lightbulb will turn on when you click lightswitch:
			lightBulb.personalAnimation = SKAction.colorize(with: .yellow, colorBlendFactor: 1, duration: 0)

			lightBulb.position = CGPoint(x: 0, y: 400)
			lightBulb.isUserInteractionEnabled = true
			addChild(lightBulb)


			// Switch:

			let lightSwitch = TouchMeSprite(color: .gray, size: CGSize(width: 25, height: 50))
			// Lightswitch will turn on lightbulb:
			lightSwitch.othersToAnimate = [lightBulb]

			lightSwitch.isUserInteractionEnabled = true
			lightSwitch.position = CGPoint(x: 0, y: 250)
			addChild(lightSwitch)
		}*/


