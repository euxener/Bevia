//
//  Item.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
