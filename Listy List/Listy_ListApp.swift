//
//  Listy_ListApp.swift
//  Listy List
//
//  Created by Tomas Sanni on 7/24/22.
//

import SwiftUI

@main
struct Listy_ListApp: App {
    @StateObject private var dataController = PersistenceController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
