//
//  String+HTML.swift
//  Trivia
//
//  Created by X Y on 3/14/24.
//

import Foundation
extension String {
    var htmlDecoded: String? {
        guard let data = data(using: .utf8) else { return nil }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        return attributedString.string
    }
}
