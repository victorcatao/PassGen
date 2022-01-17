//  Copyright © 2020 Victor Catão. All rights reserved.

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
