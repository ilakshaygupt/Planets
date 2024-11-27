//
//  InfoRow.swift
//  Planets
//
//  Created by Lakshay Gupta on 27/11/24.
//

import SwiftUI

struct InfoRow: View {
    
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.medium)
                .foregroundColor(Color(hex: 0xc4ae8a))
            Text(":")
            Text(value)
                .foregroundColor(Color(hex: 0xd46a48))
            Spacer()
        }
    }
}
