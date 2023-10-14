//
//  ContentView.swift
//  FlickrDemo
//
//  Created by Ben Walker on 13/10/2023.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    RootView()
}
