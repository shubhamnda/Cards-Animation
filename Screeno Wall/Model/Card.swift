//
//  Card.swift
//  Screeno Wall
//
//  Created by Shubham Nanda on 16/01/25.
//

import Foundation
import SwiftUI
struct Card: Identifiable {
    var id: UUID = .init()
    var cardColor : Color
    var cardName: String
    var cardBalance: String
    
}
var cards:[Card] = [
    .init(cardColor: .red, cardName: "User 1", cardBalance: "122"),.init(cardColor: .yellow, cardName: "User 2", cardBalance: "9999"),.init(cardColor: .blue, cardName: "User 3", cardBalance: "334")
]
