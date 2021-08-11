//
//  HomeViewModel.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/11.
//

import Foundation
import CoreData

class HomeViewModel: ObservableObject {
    // メモを追加する
    func addMemo(viewContext : NSManagedObjectContext, content: String){
        let newMemo = Memo(context: viewContext)
        newMemo.content = content
        newMemo.date = Date()
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("エラー： \(nsError), \(nsError.userInfo)")
        }
    }    
}
