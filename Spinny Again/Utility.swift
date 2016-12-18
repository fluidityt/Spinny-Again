//
//  Utility.swift
//  Spinny Again
//
//  Created by Dude Guy on 12/17/16.
//  Copyright © 2016 Dude Guy. All rights reserved.
//

import SpriteKit
public extension SKNode {
	func childNode(_ name: String) -> SKNode? {
		return childNode(withName: name)
	}
}
