//
//  GameScene.swift
//  Spinny Again
//
//  Created by Dude Guy on 12/14/16.
//  Copyright © 2016 Dude Guy. All rights reserved.
//

import SpriteKit
import GameplayKit


	class TouchMeSprite: SKSpriteNode {

		// This is used for when another node is pressed... the animation THIS node will run:
		var personalAnimation: SKAction?

		// This is used when THIS node is clicked... the below nodes will run their `personalAnimation`:
		var othersToAnimate: [TouchMeSprite]?

		override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

			// Early exit:
			guard let sprites = othersToAnimate else {
				print("No sprites to animate. Error?")
				return
			}

			for sprite in sprites {

				// Early exit:
				if sprite.scene == nil {
					print("sprite was nil, not running animation")
					return
				}

				// Early exit:
				guard let animation = sprite.personalAnimation else {
					print("sprite had no animation")
					return
				}

				sprite.run(animation)
			}
		}
	}

func didMoveToView() {

	let lightSwitch = TouchMeSprite(color: .yellow, size: CGSize(width: 50, height: 200))
	lightSwitch.position = CGPoint(x: 50, y: 50)


}

class GameScene: SKScene {

	var sensitivity = (min: 0.05, max: 0.45, cur: 0.2)

	func rotateClockwise() {

	 childNode(withName: "base")?.zRotation -= CGFloat(sensitivity.cur)
	}

	func rotateCounterClock() {
		childNode(withName: "base")?.zRotation += CGFloat(sensitivity.cur)
	}

	override func didMove(to: SKView) {

	func doIt() {

		//		let circle = SKShapeNode(circleOfRadius: 100)

		circle.fillColor = .white
		let dot = SKSpriteNode(texture: view?.texture(from: circle)!)
		dot.position.y -= 267
		addChild(dot)
	}

		doIt()
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
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

	}


	// MARK: - Math:



	var toucherCount = [0]
	var toucherSum = 0

	var lastFramesTime = TimeInterval()
	var dTime = TimeInterval()

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

		let x = abs(
			touches.first!.location(in: self).x
			- touches.first!.previousLocation(in: self).x
		)

		let y = x / frame.width
		var zz = y / CGFloat(dTime)
		zz/=2

		let z = Double(zz)
		if z > sensitivity.max { sensitivity.cur = sensitivity.max }
		else if z < sensitivity.min { sensitivity.cur = sensitivity.min }
		else { sensitivity.cur = z }

		toucherCount.append((1))
		toucherSum += Int(z)
		print( toucherSum / toucherCount.count)

		touches.first!.location(in: self).x > touches.first!.previousLocation(in: self).x // Move right
		? rotateClockwise()
		: rotateCounterClock()
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		toucherCount = []
		toucherSum = 0
	}


	var firstrun = true

	override func update(_ currentTime: TimeInterval) {

		if firstrun { lastFramesTime = currentTime; firstrun = false; return }
		dTime = currentTime - lastFramesTime
		lastFramesTime = currentTime
	}
}


