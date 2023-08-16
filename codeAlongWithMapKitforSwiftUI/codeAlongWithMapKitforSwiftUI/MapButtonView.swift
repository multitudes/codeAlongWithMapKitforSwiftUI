//
//  MapButtonView.swift
//  codeAlongWithMapKitforSwiftUI
//
//  Created by Laurent B on 16/08/2023.
//

import SwiftUI

struct MapButtonView: View {
    var body: some View {
        HStack {
            Button {
                search(for: "cafes")
            } label: {
                Label ("Cafes", systemImage: "cup.and.saucer.fill")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                search(for: "beach")
            } label: {
                Label ("Beaches", systemImage: "beach.umbrella")
            }
            .buttonStyle(.borderedProminent)
        }
        .labelStyle (.iconOnly)
    }
}

#Preview {
    MapButtonView()
}
