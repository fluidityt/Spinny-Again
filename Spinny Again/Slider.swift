
//
//  Clicker.swift
//  Spinny Again
//
//  Created by Dude Guy on 12/17/16.
//  Copyright © 2016 Dude Guy. All rights reserved.
//

import SpriteKit

// L R slider
class Slider: SKSpriteNode {

	var currentPercent: Int?

	private var leftBounds: CGFloat?
	private var rightBounds: CGFloat?

	func initialize(leftBoundary: CGFloat, rightBoundary: CGFloat) {
		isUserInteractionEnabled = true
		//  100   rbound
		// -  0   lbound
		// - 98   frame
		// -----
		// 
		// = 2: can move 0 spaces: (no while infinity)
		//		|-|  f  |-|
		//
		// = 4: can move 3 spaces: (minimum 3 states, 0%, 50%, 100%
		//		|-x|  f  |x-|
		//
		// object can NEVER be in an endless loop with no wiggle room.. must have interstitial space
		// 2 is minimal to not `while loop` infinity, 3 is minimal for movement, 4 is minimal for funcitonality really.

  	assert ( ((rightBoundary - leftBoundary) - frame.width) >= 3)

		leftBounds = leftBoundary
		rightBounds = rightBoundary

	}

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

		// Error check:
		guard let boundLeft  = leftBounds  else { return }
		guard let boundRight = rightBounds else { return }

		// Movement:
		position.x = (touches.first?.location(in: scene!).x)!

		// Constraints:
		while (frame.minX <= boundLeft) {
			position.x += 1
		}

		while (frame.maxX >= boundRight) {
			position.x -= 1
		}

		// Update property:
		func getPercent() -> Int {
			guard let boundLeft  = leftBounds  else { fatalError() }
			guard let boundRight = rightBounds else { fatalError() }

			let totalMovementAbility = (boundRight - boundLeft) - frame.width
			let actualDistFromLeftBorder = (frame.minX - boundLeft)

			return Int((Double(actualDistFromLeftBorder) / Double(totalMovementAbility)) * 100 + 1)
		}

		currentPercent = getPercent()
		
		
	}
}
