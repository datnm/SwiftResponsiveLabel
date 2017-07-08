//
//  PatternDescriptor.swift
//  SwiftResponsiveLabel
//
//  Created by Susmita Horrow on 02/03/16.
//  Copyright © 2016 hsusmita.com. All rights reserved.
//

import Foundation

/**
Type of Pattern Search

All : All matching patterns

First: First matching pattern

Last: Last matching pattern
*/
public enum PatternSearchType:Int {
	case all, first, last
}

/**
PatternDescriptor Struct encapsulates following information regarding pattern to be matched

Regular Expression for the pattern : NSRegularExpression

Type of pattern search : PatternSearchType

Attributes for the pattern : [String: NSObject]
*/

public struct PatternDescriptor {
	let searchType : PatternSearchType
	let patternAttributes : [String:AnyObject]?
	let patternExpression : NSRegularExpression
	
	/**
	- parameters:
		- regularExpression: An NSRegularExpression which describes the pattern
		- searchType: PatternSearchType
		- patternAttributes: [String: AnyObject] 
	- returns:
		An instance of pattern descriptor
   */
	public init(regularExpression: NSRegularExpression, searchType: PatternSearchType, patternAttributes: [String:AnyObject]?) {
		self.patternExpression = regularExpression
		self.searchType = searchType
		self.patternAttributes = patternAttributes
	}
	
	/**
	Returns a pattern descriptor
	- parameters:
		- dataDetector: NSDataDetector
		- searchType: PatternSearchType
		- patternAttributes: [String: AnyObject]
	- returns:
		An instance of pattern descriptor
	*/
	public init(dataDetector: NSDataDetector, searchType: PatternSearchType, patternAttributes: [String:AnyObject]?) {
		self.patternExpression = dataDetector
		self.searchType = searchType
		self.patternAttributes = patternAttributes
	}

	/**
	Generates array of ranges for the matches found in given string, based on current search type.
	
	If searchType = .All, all the matches are returned
	
	If searchType = .First, the array contains only the first found range
	
	if searchType = .Last, the array contains only the last found range
	
	- parameters:
		- string: Input String
	- returns:
		An array of NSRange
	*/
	public func patternRangesForString(_ string:String) -> [NSRange] {
		switch(self.searchType) {

		case .all:
			return allMatchingPattern(string)

		case .first:
			return [firstMatchingPattern(string)]

		case .last:
			return [allMatchingPattern(string)].last!
		}
	}
	
	// MARK: - Private Helpers

	fileprivate func allMatchingPattern(_ string:String) -> [NSRange] {
		var generatedRanges = [NSRange]()
		self.patternExpression.enumerateMatches(in: string, options: .reportCompletion, range: NSMakeRange(0, string.characters.count)){
		 (result, flag, stop) -> Void in
			if let result = result {
				generatedRanges.append(result.range)
			}
		}

		return generatedRanges
	}
	
	fileprivate func firstMatchingPattern(_ string:String) -> NSRange {
		return self.patternExpression.rangeOfFirstMatch(in: string, options: .reportProgress, range: NSMakeRange(0, string.characters.count))
	}
}
