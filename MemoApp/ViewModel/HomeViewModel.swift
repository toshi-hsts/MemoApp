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
            // メモ配列を初期化
            memos = []
            // CoreDataのメモをPublished変数に読み込む
            fetchedMemos.forEach{
                memos.append(MemoModel(isSelected: false, memo: $0))
            }
        }
        catch {
            let nsError = error as NSError
            fatalError("エラー： \(nsError), \(nsError.userInfo)")
        }
    }    
    // isSelectedプロパティをfalseにする
    func resetSelectedPropery(){
        for i in 0 ..< memos.count {
            memos[i].isSelected = false
        }
    }
    // メモを削除する
    func deleteMemo(viewContext : NSManagedObjectContext) {
        for i in 0 ..< memos.count {
            if memos[i].isSelected {
                viewContext.delete(memos[i].memo)
            }
        }
        
        do {
            try viewContext.save()
            loadMemos(viewContext: viewContext)
        } catch {
            let nsError = error as NSError
            fatalError("エラー： \(nsError), \(nsError.userInfo)")
        }
    }
}
