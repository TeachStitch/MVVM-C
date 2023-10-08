//
//  String.swift
//

import UIKit

extension String {
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
        else { return nil }
        return from ..< to
    }
    
    func base64Decoded() -> String? {
        var string = replacingOccurrences(of: "-", with: "+")
        string = string.replacingOccurrences(of: "_", with: "/")
        
        switch (string.utf8.count % 4) {
        case 2:
            string += "=="
        case 3:
            string += "="
        default:
            break
        }
        
        guard let data = Data(base64Encoded: string, options: [.ignoreUnknownCharacters]) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

// Style attributed
extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: .zero, length: attributeString.length))
        
        return attributeString
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = capitalizingFirstLetter()
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        return try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil
        )
    }
}

extension String {
    /// for this type of strings "10:00"
    func convertToTimeInterval() -> TimeInterval {
        guard !self.isEmpty else { return .zero }
        
        var interval = TimeInterval.zero
        
        for (index, part) in components(separatedBy: ":").reversed().enumerated() {
            interval += (Double(part) ?? .zero) * pow(Double(60), Double(index + 1))
        }
        
        return interval
    }
}
