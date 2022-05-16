//
//  String+.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/19.
//

import UIKit

extension String {
    
    func range(of subString: String) -> NSRange? {
        return (self as NSString).range(of: subString)
    }
    
    func attributeFontAsTag(startTag: String, endTag: String, attributes: [NSAttributedString.Key: Any]) -> NSMutableAttributedString? {
        guard self.contains(startTag) && self.contains(endTag) else { return nil }
        
        let attributeString = NSMutableAttributedString(string: self)
        
        var string = self
        while let startRange = string.range(of: startTag, range: string.startIndex..<string.endIndex) {
            guard let endRange = string.range(of: endTag, range: startRange.upperBound..<string.endIndex) else { continue }
            
            let attributeRange = NSRange(startRange.upperBound..<endRange.lowerBound, in: string)
            attributeString.addAttributes(attributes, range: attributeRange)
            attributeString.mutableString.replaceOccurrences(of: endTag, with: "", range: NSRange(endRange, in: string))
            attributeString.mutableString.replaceOccurrences(of: startTag, with: "", range: NSRange(startRange, in: string))
            
            string = attributeString.mutableString as String
        }
        return attributeString
    }
    
    func trimmingLeadingAndTrailingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        return trimmingCharacters(in: characterSet)
    }
    
}
