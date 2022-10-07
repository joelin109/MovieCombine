//
//  MovieCombineApp.swift
//  MovieCombine
//
//  Created by Joe Lin on 16.09.22.
//

import SwiftUI

@main
struct MovieCombineApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}


struct MainView: View {
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
        MainView()
    }
}
