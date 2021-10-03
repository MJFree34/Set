//
//  SetApp.swift
//  Set
//
//  Created by Matt Free on 8/21/21.
//

import SwiftUI

@main
struct SetApp: App {
    private let game = StandardSetGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(game: game)
        }
    }
}
