//
//  CaredRectKey.swift
//  Screeno Wall
//
//  Created by Shubham Nanda on 16/01/25.
//

import Foundation
import SwiftUI
struct CardRectKey: PreferenceKey {
    static var defaultValue: [String : Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
    
}
