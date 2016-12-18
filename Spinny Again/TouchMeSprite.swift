//
//  TouchMeSprite.swift
//  Spinny Again
//
//  Created by Dude Guy on 12/17/16.
//  Copyright © 2016 Dude Guy. All rights reserved.
//

import SpriteKit
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
	
