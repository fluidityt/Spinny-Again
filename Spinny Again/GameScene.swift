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
	func minSlider()		 -> Slider { return childNode("slider cyan")   as! Slider }
	func maxSlider()	   -> Slider { return childNode("slider yellow") as! Slider }
	func divSlider()		 -> Slider { return childNode("slider pink")   as! Slider }

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
	                   maxCur: 0.85,
	                   divCur: 6.0,
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

	// Enemies:
	func ballCyan() -> SKSpriteNode {
		return childNode("ball cyan")		as! SKSpriteNode
	}
	func ballYellow() -> SKSpriteNode {
		return childNode("ball yellow")  as! SKSpriteNode
	}
	func ballPink() -> SKSpriteNode{
		return childNode("ball pink") as! SKSpriteNode
	}
	func bkg() -> SKShapeNode { return childNode("bkg") as! SKShapeNode }

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

	enum time {
		static var ticks   = 0
		static var seconds = 0
	}

	private func spawn() {
		// Pick random color:
		func randomColorSprite() -> SKSpriteNode {
			let result = arc4random_uniform(99)

			if result > 66 { return ballCyan() }
			if result < 33 { return ballYellow() }
			return ballPink()
		}


		// Pick random side to spawn from:
		enum Sides { case top, left, bottom, right }
		func randomSideToSpawnOn() -> Sides {
			let result = arc4random_uniform(99)
			switch result {
				case 0...25 : return Sides.top
				case 26...50: return Sides.right
				case 51...75: return Sides.bottom
				default:	return Sides.left
			}
		}

		// Pick random X and Y location on BKG border:
		func randomBkgBorderPos(side: Sides) -> CGPoint {
			// God I hate the RNG gods...
			let randomX = CGFloat(arc4random_uniform(UInt32(bkg().frame.width)))
			let randomY = CGFloat(arc4random_uniform(UInt32(bkg().frame.height)))

			// Make sure that this isn't weird
			print(randomX, randomY)
			// FIXME: adjust for offset...
			switch side {
				case .top:	  return CGPoint(x: randomX, y: bkg().frame.maxY)
				case .right:  return CGPoint(x: bkg().frame.maxX, y: randomY)
				case .bottom: return CGPoint(x: randomX, y: bkg().frame.minY)
				case .left:		return CGPoint(x: bkg().frame.minX, y: randomY)
			}
		}


		// Set right node to location:
		let rightNode = randomColorSprite()
		rightNode.position = randomBkgBorderPos(side: randomSideToSpawnOn())

		// Set node to move to center:
		rightNode.run(.move(to: bkg().center(), duration: 2),
		              completion: {
										rightNode.run(.move(to: { self.childNode("pergatory")! as! SKLabelNode}().position, duration: 0))})
	}

	override func update(_ currentTime: TimeInterval) {

		// Initial stuff:
		if firstrun {
			lastFramesTime = currentTime
			firstrun = false
			return
		}

		// Time stuff:
		dTime					 = (currentTime - lastFramesTime)
		lastFramesTime = currentTime

		// Sliders:
		// FIXME: Set up dispatch
		//doSliders()

		// Spawners:
		time.ticks += 1; if time.ticks >= 60 { time.seconds += 1; time.ticks = 0 }; if time.seconds >= 3 { time.seconds = 0
			spawn()
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


