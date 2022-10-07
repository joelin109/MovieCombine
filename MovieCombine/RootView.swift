//
//  ContentView.swift
//  MovieCombine
//
//  Created by Joe Lin on 16.09.22.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        MovieHomePage()
//        TabView {
//            MovieHomePage()
//                .tabItem {
//                    Image(systemName: "film")
//                    Text("Movies")
//                }.tag(0)
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
