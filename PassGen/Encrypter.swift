//  Copyright © 2020 Victor Catão. All rights reserved.

import Foundation

final class Encrypter {
    
    private init() {}
    
    /// Singleton shared instance
    static let shared = Encrypter()

    /// A random prime number to be multiplied and generate a new random number to insert at the beginning the encrypted password
    private let firstRandomPrimeNumber = 7
    /// A random prime number to be multiplied and generate a new random number to insert at the end of the encrypted password
    private let secondRandomPrimeNumber = 13
    /// The maximum size for the encrypted text
    private let maximumCipherSize = 4
    /// Special characters to be insert into the encrypted password
    private let specialCharacters = ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")"]

    /// Main function to encrypt the input text
    /// - Parameter text: User input to be encrypted
    /// - Returns: The encrypted string
    func encrypt(text: String) -> String {
        let textSize = text.count
        
        let initialNumber = String(textSize * firstRandomPrimeNumber)
        let finalNumber = String(textSize * secondRandomPrimeNumber)
        let caesarCipher = caesarCipher(message: String(text.suffix(maximumCipherSize)),
                                        shift: textSize)
        let caesarCipherCapitalized = caesarCipher.lowercased().capitalizingFirstLetter()
        let specialCharacterIndex = textSize % specialCharacters.count
        let specialCharacter = specialCharacters[specialCharacterIndex]
        
        return initialNumber + caesarCipherCapitalized + specialCharacter + finalNumber
    }
    
    /// Credit: Martin R - https://codereview.stackexchange.com/a/172058
    private func caesarCipher(message: String, shift: Int) -> String {
        
        func shiftLetter(ucs: UnicodeScalar) -> UnicodeScalar {
            let firstLetter = Int(UnicodeScalar("A").value)
            let lastLetter = Int(UnicodeScalar("Z").value)
            let letterCount = lastLetter - firstLetter + 1
            
            let value = Int(ucs.value)
            switch value {
            case firstLetter...lastLetter:
                // Offset relative to first letter:
                var offset = value - firstLetter
                // Apply shift amount (can be positive or negative):
                offset += shift
                // Transform back to the range firstLetter...lastLetter:
                offset = (offset % letterCount + letterCount) % letterCount
                // Return corresponding character:
                return UnicodeScalar(firstLetter + offset)!
            default:
                // Not in the range A...Z, leave unchanged:
                return ucs
            }
        }

        let crypto = String(String.UnicodeScalarView(message.uppercased().unicodeScalars.map(shiftLetter)))
        return crypto
    }
    
}
