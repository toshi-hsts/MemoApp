//
//  HomeViewModel.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/11.
//

import Foundation
import CoreData

class HomeViewModel: ObservableObject {
    @Published var memos: [MemoModel] = []
    // メモを追加する
    func addMemo(viewContext : NSManagedObjectContext, content: String){
        let newMemo = Memo(context: viewContext)
        newMemo.content = content
        newMemo.date = Date()
        
        do {
            try viewContext.save()
            loadMemos(viewContext: viewContext)
        } catch {
            let nsError = error as NSError
            fatalError("エラー： \(nsError), \(nsError.userInfo)")
        }
    }
    // メモを取得する
    func loadMemos(viewContext : NSManagedObjectContext){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        
        // dateで昇順にソート
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let fetchedMemos = try viewContext.fetch(request) as! [Memo]
            fetchedMemos.forEach{
                memos.append(MemoModel(isSelected: false, memo: $0))
            }
        }
        catch {
            let nsError = error as NSError
            fatalError("エラー： \(nsError), \(nsError.userInfo)")
        }
    }
}
