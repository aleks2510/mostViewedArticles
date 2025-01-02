//
//  AnchorKey.swift
//  CodeChallengeRaven
//
//  Created by Alejandro Lopez Villalobos on 01/01/25.
//

import SwiftUI

struct AnchorKey: PreferenceKey {
    static var defaultValue: [String : Anchor<CGRect>] = [:]
    static func reduce(value: inout [String:Anchor<CGRect>], nextValue: ()-> [String:Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}
