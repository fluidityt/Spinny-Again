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

	// Sliders:
	 func minSlider()		 -> Slider { return childNode("ball cyan")   as! Slider }
	 func maxSlider()	   -> Slider { return childNode("ball yellow") as! Slider }
	 func divSlider()		 -> Slider { return childNode("ball pink")   as! Slider }

	// Labels:
	 func minLabel()			 -> SKLabelNode { return childNode("min") as! SKLabelNode }
	 func maxLabel()			 -> SKLabelNode { return childNode("max") as! SKLabelNode }
	 func divLabel()			 -> SKLabelNode { return childNode("div") as! SKLabelNode }
	 func curLabel()			 -> SKLabelNode { return childNode("cur") as! SKLabelNode }

	// Sensitivites:
	 let sensitivityMinRef = (min: 0.006, max: 0.05 ),
			sensitivityMaxRef = (min: 0.45,   max: 0.85),
			sensitivityDivRef = (min: 12.0,    max: 2.0  )

	 var sensitivity = (minCur: 0.006,
	                   maxCur: 0.45,
	                   divCur: 12.0,
	                   curCur: 0.2)

	func doSliders() {

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

		setMinToSlider()
		setMaxToSlider()
		setDivToSlider()

		// Make numbers more human readable:
		curLabel().text = "Current: " + String(Int(sensitivity.curCur*1000))
		minLabel().text = "min: "			+ String(Int(sensitivity.minCur*1000))
		maxLabel().text = "max: "			+ String(Int(sensitivity.maxCur*1000))
		divLabel().text = "div: "			+ String(Int(sensitivity.divCur))

	}

	// Spinning:
  var lastFramesTime = TimeInterval()
	var dTime = TimeInterval()
	var firstrun = true
	}

// DMV:
extension GameScene {
private func makeBalls() {
			// Iterations of our EditorNodes
			let colors = ["cyan", "yellow", "pink"];					/**/ for color in colors {
				let name = "ball" + " " + color;								/**/ let ball = childNode(name) as! SKSpriteNode
				let circle = SKShapeNode(circleOfRadius: 512);	/**/ circle.isAntialiased = true;
				circle.fillColor = ball.color;						  		/**/ ball.texture = view!.texture(from: circle)!
				// FIXME: set up physics body to bounding circle
				ball.texture!.usesMipmaps = true;								/**/ ball.setScale(0.5)
			}
		}

	override func didMove(to: SKView) {

		makeBalls()

		minSlider().initialize(leftBoundary: frame.minX, rightBoundary: frame.maxX)
		maxSlider().initialize(leftBoundary: frame.minX, rightBoundary: frame.maxX)
		divSlider().initialize(leftBoundary: frame.minX, rightBoundary: frame.maxX)

		doSliders()

		print(sensitivity.minCur)
		print(sensitivity.maxCur)
		print(sensitivity.divCur)
	}
}

// Touches:
extension GameScene {

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		// FIXME: Refac to pure:
		func setSensDotCur() {
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
		}
		func spinClockwise() {
			childNode("base")!.zRotation -= CGFloat(sensitivity.curCur)
		}
		func spinCounterClockwise() {

			childNode("base")!.zRotation += CGFloat(sensitivity.curCur)
		}



		// Implement:
		setSensDotCur()
		touches.first!.location(in: self).x > touches.first!.previousLocation(in: self).x // Move right
			? spinClockwise()
			: spinCounterClockwise()
		print(sensitivity.curCur)
	}

}

// Update:
extension GameScene {
	override func update(_ currentTime: TimeInterval) {

		if firstrun { lastFramesTime = currentTime; firstrun = false; return }

		dTime = currentTime - lastFramesTime
		lastFramesTime = currentTime

		doSliders()
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


