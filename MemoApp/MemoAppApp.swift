//
//  MemoAppApp.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/06.
//

import SwiftUI

@main
struct MemoAppApp: App {
    // NSPersistentContainerの初期化
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                // 環境変数にNSManagedObjectContextを登録
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
