
//
//  Clicker.swift
//  Spinny Again
//
//  Created by Dude Guy on 12/17/16.
//  Copyright © 2016 Dude Guy. All rights reserved.
//

import SpriteKit

class Slider: SKSpriteNode {

	var publicAccel = 0

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

		position.x = (touches.first?.location(in: scene!).x)!

		// Constraints:
		while (frame.minX <= (scene?.frame.minX)!) {
			position.x += 1
		}

		while (frame.maxX >= (scene?.frame.maxX)!) {
			position.x -= 1

		}

	}
}
