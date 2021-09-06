//
//  CoreDataModel.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/26.
//

import Foundation
import CoreData

class CoreDataModel{
    // NSPersistentContainerの初期化
    private let persistenceContainer = PersistenceController.shared.container
    // viewContextを定義
    private var viewContext: NSManagedObjectContext {
        return persistenceContainer.viewContext
    }
    // DB保存前の領域にinsert登録
    func insert(_ object: NSManagedObject) {
        viewContext.insert(object)
    }
    // DB保存前の領域にdelete登録
    func delete(_ object: NSManagedObject) {
        viewContext.delete(object)
    }
    // DBに保存
    func save() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("エラー： \(nsError), \(nsError.userInfo)")
        }
    }
}

extension CoreDataModel{
    // 新しいメモを生成
    func newMemo() -> Memo {
        let entity = NSEntityDescription.entity(forEntityName: "Memo", in: viewContext)!
        let memo = Memo(entity: entity, insertInto: nil)
        return memo
    }
    
    // メモを読み込む
    func fetchMemos() -> [Memo]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        
        // dateで昇順にソート
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try viewContext.fetch(request) as! [Memo]            
        }
        catch {
            let nsError = error as NSError
            fatalError("エラー： \(nsError), \(nsError.userInfo)")
        }
    }
}

