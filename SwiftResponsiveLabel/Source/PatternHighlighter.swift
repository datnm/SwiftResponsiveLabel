//
//  PatternHighlighter.swift
//  SwiftResponsiveLabel
//
//  Created by Susmita Horrow on 02/03/16.
//  Copyright © 2016 hsusmita.com. All rights reserved.
//

import Foundation

/** This class is reponsible for finding patterns and applying attributes to those patterns
*/

open class PatternHighlighter {
	static let RegexStringForHashTag = "(?<!\\w)#([\\w\\_]+)?"
	static let RegexStringForUserHandle = "(?<!\\w)@([\\w\\_]+)?"
	static let RegexFormatForSearchWord = "(%@)"

	var patternHighlightedText: NSMutableAttributedString?
	fileprivate var patternDescriptors: [String: PatternDescriptor] = [:]
	fileprivate var attributedText: NSMutableAttributedString?
	
	/** Update current attributed text and apply attributes based on current patternDescriptors
	- parameters:
		- attributedText: NSAttributedString
	*/
	func updateAttributedText(_ attributedText: NSAttributedString) {
		self.attributedText = NSMutableAttributedString(attributedString: attributedText)
		self.patternHighlightedText = self.attributedText
		for descriptor in self.patternDescriptors {
			self.enablePatternDetection(descriptor.1)
		}
	}
	
	/** Add attributes to the range of strings matching the given regex string
	- parameters:
		- regexString: String
		- dictionary: [String:AnyObject]
	*/
	func highlightPattern(_ regexString: String, dictionary: [String:AnyObject]) {
		do {
			let regex = try NSRegularExpression(pattern: regexString, options: .caseInsensitive)
			let descriptor = PatternDescriptor(regularExpression: regex, searchType: PatternSearchType.all, patternAttributes: dictionary)
			self.enablePatternDetection(descriptor)
		} catch let error as NSError {
			print("NSRegularExpression Error: \(error.debugDescription)")
		}
	}

	/** Removes attributes from the range of strings matching the given regex string
	- parameters:
		- regexString: String
	*/
	func unhighlightPattern(regexString: String) {
		if let descriptor = self.patternDescriptors[regexString] {
			self.removePatternAttributes(descriptor)
			self.patternDescriptors.removeValue(forKey: regexString)
		}
	}
	
	/** Detects patterns, applies attributes defined as per patternDescriptor and handles touch(If RLTapResponderAttributeName key is added in dictionary)
	- parameters:
		- patternDescriptor: PatternDescriptor
	
		- This object encapsulates the regular expression and attributes to be added to the pattern.
	*/
	func enablePatternDetection(_ patternDescriptor:PatternDescriptor) {
		let patternKey = patternNameKeyForPatternDescriptor(patternDescriptor)
		patternDescriptors[patternKey] = patternDescriptor
		addPatternAttributes(patternDescriptor)
	}
	
	/** Removes previously applied attributes from all the occurance of pattern dictated by pattern descriptor
	- parameters:
		- patternDescriptor: PatternDescriptor
	*/
	func disablePatternDetection(_ patternDescriptor:PatternDescriptor) {
		let patternKey = patternNameKeyForPatternDescriptor(patternDescriptor)
		patternDescriptors.removeValue(forKey: patternKey)
		removePatternAttributes(patternDescriptor)
	}
	
	// MARK: - Private Helpers
	
	fileprivate func patternNameKeyForPatternDescriptor(_ patternDescriptor:PatternDescriptor)-> String {
		let key:String
		if patternDescriptor.patternExpression.isKind(of: NSDataDetector.self) {
			let types = (patternDescriptor.patternExpression as! NSDataDetector).checkingTypes
			key = String(types)
		}else {
			key = patternDescriptor.patternExpression.pattern;
		}
		return key
	}

	fileprivate func removePatternAttributes(_ patternDescriptor:PatternDescriptor) {
		guard let attributedText = self.attributedText else {
			return
		}
		//Generate ranges for current text of textStorage
		let patternRanges = patternDescriptor.patternRangesForString(attributedText.string)
		for range in patternRanges { //Remove attributes from the ranges conditionally
			if let attributes = patternDescriptor.patternAttributes {
				for (name, _) in attributes {
					attributedText.removeAttribute(name, range: range)
				}
			}
		}
	}

	fileprivate func addPatternAttributes(_ patternDescriptor:PatternDescriptor) {
		guard let attributedText = self.patternHighlightedText else {
			return
		}
		//Generate ranges for attributed text of the label
		let patternRanges = patternDescriptor.patternRangesForString(attributedText.string)
		for range in patternRanges { //Apply attributes to the ranges conditionally
			attributedText.addAttributes(patternDescriptor.patternAttributes!, range: range)
		}
	}
}
