//
//  TouchHandler.swift
//  SwiftResponsiveLabel
//
//  Created by Susmita Horrow on 01/03/16.
//  Copyright © 2016 hsusmita.com. All rights reserved.
//

import Foundation
import UIKit.UIGestureRecognizerSubclass

class TouchGestureRecognizer: UIGestureRecognizer {

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesBegan(touches, with: event)
		self.state = .began
	}

	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesCancelled(touches, with: event)
		self.state = .cancelled
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesEnded(touches, with: event)
		self.state = .ended
	}
}

class TouchHandler: NSObject {
	fileprivate var responsiveLabel: SwiftResponsiveLabel?

	var touchIndex: Int?
	var selectedRange: NSRange?
	fileprivate var defaultAttributes: [String: AnyObject]?
	fileprivate var highlightAttributes: [String: AnyObject]?
	
	init(responsiveLabel: SwiftResponsiveLabel) {
		super.init()
		self.responsiveLabel = responsiveLabel
		let gestureRecognizer = TouchGestureRecognizer(target: self, action: #selector(TouchHandler.handleTouch(_:)))
		self.responsiveLabel?.addGestureRecognizer(gestureRecognizer)
		gestureRecognizer.delegate = self
	}

	@objc fileprivate func handleTouch(_ gesture: UIGestureRecognizer) {
		let touchLocation = gesture.location(in: self.responsiveLabel)
		let index = self.responsiveLabel?.textKitStack.touchedCharacterIndexAtLocation(touchLocation)
		self.touchIndex = index

		switch gesture.state {
		case .began:
			self.beginSession()
		case .cancelled:
			self.cancelSession()
		case .ended:
			self.endSession()
		default:
			return
		}
	}

	fileprivate func beginSession() {
		guard let textkitStack = self.responsiveLabel?.textKitStack,
			  let touchIndex = self.touchIndex, self.touchIndex! < textkitStack.textStorageLength  else { return }
		var rangeOfTappedText = NSRange()
		let highlightAttributeInfo = textkitStack.rangeAttributeForKey(RLHighlightedAttributesDictionary, atIndex: touchIndex)
		rangeOfTappedText = highlightAttributeInfo.range
		self.highlightAttributes = highlightAttributeInfo.attribute as? [String : AnyObject]
		if let attributes = self.highlightAttributes {
			self.selectedRange = rangeOfTappedText
			self.defaultAttributes = [String : AnyObject]()
			for (key, value) in attributes {
				self.defaultAttributes![key] = textkitStack.rangeAttributeForKey(key, atIndex: touchIndex).attribute
				textkitStack.addAttribute(value, forkey: key, atRange: rangeOfTappedText)
			}
			self.responsiveLabel?.setNeedsDisplay()
		}
		if self.selectedRange == nil {
			if let _ = textkitStack.rangeAttributeForKey(RLTapResponderAttributeName, atIndex: touchIndex).attribute as? PatternTapResponder {
				self.selectedRange = rangeOfTappedText
			}
		}
	}

	fileprivate func cancelSession() {
		self.removeHighlight()
	}

	fileprivate func endSession() {
		self.performActionOnSelection()
		self.removeHighlight()
	}

	fileprivate func removeHighlight() {
		guard let textkitStack = self.responsiveLabel?.textKitStack,
			let selectedRange = self.selectedRange,
			let highlightAttributes = self.highlightAttributes,
			let defaultAttributes = self.defaultAttributes else {
				self.resetGlobalVariables()
				return
			}
		for (key, _) in highlightAttributes {
			textkitStack.removeAttribute(forkey: key, atRange: selectedRange)
			if let defaultValue = defaultAttributes[key] {
				textkitStack.addAttribute(defaultValue, forkey: key, atRange: selectedRange)
			}
		}

		self.responsiveLabel?.setNeedsDisplay()
		self.resetGlobalVariables()
	}
	
	private func resetGlobalVariables() {
		self.selectedRange = nil
		self.defaultAttributes = nil
		self.highlightAttributes = nil
	}
	
	fileprivate func performActionOnSelection() {
		guard let textkitStack = self.responsiveLabel?.textKitStack, let selectedRange = self.selectedRange else { return }
		if let tapResponder = textkitStack.rangeAttributeForKey(RLTapResponderAttributeName, atIndex: selectedRange.location).attribute as? PatternTapResponder {
			let tappedString = textkitStack.substringForRange(selectedRange)
			tapResponder.perform(tappedString)
		}
	}
}

extension TouchHandler : UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		let touchLocation = touch.location(in: self.responsiveLabel)
		guard let textkitStack = self.responsiveLabel?.textKitStack,
			let index = self.responsiveLabel?.textKitStack.touchedCharacterIndexAtLocation(touchLocation), index < textkitStack.textStorageLength
		 else {
		 	return false
		}
		let keys = textkitStack.rangeAttributesAtIndex(index).map { $0.key }
		return keys.contains(RLHighlightedAttributesDictionary) || keys.contains(RLTapResponderAttributeName)
	}
}
