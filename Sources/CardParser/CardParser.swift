//
//  CardParser.swift
//
//  Created by Jason Clark on 6/28/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

//MARK: - CardType

public enum CardType: CaseIterable {
    case amex
    case diners
    case discover
    case jcb
    case masterCard
    case visa

    private var validationRequirements: ValidationRequirement {
        let prefix: [PrefixContainable], length: [Int]

        switch self {
        /* // IIN prefixes and length requriements retreived from https://en.wikipedia.org/wiki/Bank_card_number on June 28, 2016 */

        case .amex:         prefix = ["34", "37"]
                            length = [15]

        case .diners:       prefix = ["300"..."305", "309", "36", "38"..."39"]
                            length = [14]

        case .discover:     prefix = ["6011", "65", "644"..."649", "622126"..."622925"]
                            length = [16]

        case .jcb:          prefix = ["3528"..."3589"]
                            length = [16]

        case .masterCard:   prefix = ["51"..."55", "2221"..."2720"]
                            length = [16]

        case .visa:         prefix = ["4"]
                            length = [13, 16, 19]

        }

        return ValidationRequirement(prefixes: prefix, lengths: length)
    }

    public var segmentGroupings: [Int] {
        switch self {
        case .amex:      return [4, 6, 5]
        case .diners:    return [4, 6, 4]
        default:         return [4, 4, 4, 4]
        }
    }

    public var maxLength: Int {
        return validationRequirements.lengths.max() ?? 16
    }

    public var cvvLength: Int {
        switch self {
        case .amex: return 4
        default: return 3
        }
    }

    public func isValid(_ accountNumber: String) -> Bool {
        return validationRequirements.isValid(accountNumber) && CardType.luhnCheck(accountNumber)
    }

    public func isPrefixValid(_ accountNumber: String) -> Bool {
        return validationRequirements.isPrefixValid(accountNumber)
    }

}

fileprivate extension CardType {

    struct ValidationRequirement {
        let prefixes: [PrefixContainable]
        let lengths: [Int]

        func isValid(_ accountNumber: String) -> Bool {
            return isLengthValid(accountNumber) && isPrefixValid(accountNumber)
        }

        func isPrefixValid(_ accountNumber: String) -> Bool {
            guard prefixes.count > 0 else { return true }
            return prefixes.contains { $0.hasCommonPrefix(with: accountNumber) }
        }

        func isLengthValid(_ accountNumber: String) -> Bool {
            guard lengths.count > 0 else { return true }
            return lengths.contains { accountNumber.count == $0 }
        }
    }

    // from: https://gist.github.com/cwagdev/635ce973e8e86da0403a
    static func luhnCheck(_ cardNumber: String) -> Bool {
        var sum = 0
        let reversedCharacters = cardNumber.reversed().map { String($0) }
        for (idx, element) in reversedCharacters.enumerated() {
            guard let digit = Int(element) else { return false }
            switch ((idx % 2 == 1), digit) {
            case (true, 9): sum += 9
            case (true, 0...8): sum += (digit * 2) % 9
            default: sum += digit
            }
        }
        return sum % 10 == 0
    }

}

//MARK: - CardState

public enum CardState: Equatable {
    case identified(CardType)
    case indeterminate([CardType])
    case invalid
}

extension CardState {

    public init(fromNumber number: String) {
        if let card = CardType.allCases.first(where: { $0.isValid(number) }) {
            self = .identified(card)
        }
        else {
            self = .invalid
        }
    }

    public init(fromPrefix prefix: String) {
        let possibleTypes = CardType.allCases.filter { $0.isPrefixValid(prefix) }
        if possibleTypes.count >= 2 {
            self = .indeterminate(possibleTypes)
        }
        else if possibleTypes.count == 1, let card = possibleTypes.first {
            self = .identified(card)
        }
        else {
            self = .invalid
        }
    }

}

//MARK: - PrefixContainable

fileprivate protocol PrefixContainable {

    func hasCommonPrefix(with text: String) -> Bool

}

extension ClosedRange: PrefixContainable {

    func hasCommonPrefix(with text: String) -> Bool {
        //cannot include Where clause in protocol conformance, so have to ensure Bound == String :(
        guard let lower = lowerBound as? String, let upper = upperBound as? String else { return false }

        let trimmedRange: ClosedRange<String> = {
            let length = text.count
            let trimmedStart = String(lower.prefix(length))
            let trimmedEnd = String(upper.prefix(length))
            return trimmedStart...trimmedEnd
        }()

        let trimmedText = String(text.prefix(trimmedRange.lowerBound.count))
        return trimmedRange ~= trimmedText
    }

}

extension String: PrefixContainable {
    
    func hasCommonPrefix(with text: String) -> Bool {
        return hasPrefix(text) || text.hasPrefix(self)
    }
    
}

