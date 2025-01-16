//
//  CustomCorner.swift
//  Screeno Wall
//
//  Created by Shubham Nanda on 16/01/25.
//

import Foundation
import SwiftUI
struct CustomCorner: Shape {
  var corners : UIRectCorner
    var radius: CGFloat
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
