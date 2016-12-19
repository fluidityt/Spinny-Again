//
//  GameScene.swift
//  Spinny Again
//
//  Created by Dude Guy on 12/14/16.
//  Copyright © 2016 Dude Guy. All rights reserved.
//

import SpriteKit
import GameplayKit


// Propfuncs:
class GameScene: SKScene {

	func minSlider()		 -> Slider { return childNode("ball cyan")   as! Slider }
	func maxSlider()	   -> Slider { return childNode("ball yellow") as! Slider }
	func divSlider()		 -> Slider { return childNode("ball pink")   as! Slider }

	func minLabel()			 -> SKLabelNode { return childNode("min") as! SKLabelNode }
	func maxLabel()			 -> SKLabelNode { return childNode("max") as! SKLabelNode }
	func divLabel()			 -> SKLabelNode { return childNode("div") as! SKLabelNode }

	let sensitivityMinRef = (min: 0.0125, max: 0.05 ),
			sensitivityMaxRef = (min: 0.45,   max: 0.845),
			sensitivityDivRef = (min: 8.0,    max: 2.0  )

	var sensitivity = (minCur: 0.0125,
	                   maxCur: 0.845,
	                   divCur: 2.0,
	                   curCur: 0.2)

	func setMinToSlider() {
		guard let percent = minSlider().currentPercent else { return }
		let (min, max) = (sensitivityMinRef.min, sensitivityMinRef.max)
		if min == Double(percent) { return }

		sensitivity.minCur =
			min
			+ (max - min)
			* (Double(percent) / 100)
	}

	func setMaxToSlider() {
		guard let percent = maxSlider().currentPercent else { return }
		let (min, max) = (sensitivityMaxRef.min, sensitivityMaxRef.max)
		if min == Double(percent) { return }

		sensitivity.maxCur =
			min
			+ (max - min)
			* (Double(percent) / 100)
	}

	func setDivToSlider() {
		guard let percent = divSlider().currentPercent else { return }
		let (min, max) = (sensitivityDivRef.min, sensitivityDivRef.max)
		if min == Double(percent) { return }

		sensitivity.divCur =
			min
			+ (max - min)
			* (Double(percent) / 100)
	}

	// Actual mins:
	// 025 = 4  slow
	// 05  = 2	normal
	// .1  = 1	fast
	var scaleFactor = CGFloat(7)

	var toucherCount = [0]
	var toucherSum = 0

	var lastFramesTime = TimeInterval()
	var dTime = TimeInterval()
	var firstrun = true


 func clockwise() {
	childNode(withName: "base")!.zRotation -= CGFloat(sensitivity.curCur)
	}

	func counterClockwise() {
		childNode(withName: "base")!.zRotation += CGFloat(sensitivity.curCur)
	}
	
}

// DMV:
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

		minSlider().initialize(leftBoundary: frame.minX, rightBoundary: frame.maxX)
		maxSlider().initialize(leftBoundary: frame.minX, rightBoundary: frame.maxX)
		divSlider().initialize(leftBoundary: frame.minX, rightBoundary: frame.maxX)
	}
}

// Touches:
extension GameScene {

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
		zz /= CGFloat(sensitivity.divCur)

		let z = Double(zz)
		if z > sensitivity.maxCur			 { sensitivity.curCur = sensitivity.maxCur }
		else if z < sensitivity.minCur { sensitivity.curCur = sensitivity.minCur }
		else { sensitivity.curCur = z }

			//	print(zz)
			print(sensitivity.curCur)
			//print("\n")*/
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

}

// Update:
extension GameScene {
	override func update(_ currentTime: TimeInterval) {

		if firstrun { lastFramesTime = currentTime; firstrun = false; return }
		dTime = currentTime - lastFramesTime
		lastFramesTime = currentTime

		//		sensitivity.max = maxSlider().currentPercent
		setMinToSlider()
		setMaxToSlider()
		setDivToSlider()

		if minLabel().text != String(sensitivity.minCur) {
			minLabel().text = "min: " + String(sensitivity.minCur)
			//			print("min: ", sensitivity.minCur)

			}

		if maxLabel().text != String(sensitivity.maxCur) {
			maxLabel().text = "max: " + String(sensitivity.maxCur)
			// print("max: ", sensitivity.maxCur)

			}

		if divLabel().text != String(sensitivity.divCur) {
			divLabel().text = String(sensitivity.divCur)
			// print("div: ", sensitivity.divCur)

			}

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


