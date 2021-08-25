//
//  HomeViewModel.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/11.
//

import Foundation
import CoreData

class HomeViewModel: ObservableObject {
    // メモ配列
    @Published var memos: [MemoModel] = []
    // メモ削除画面への切り替え
    @Published var isDeleteMode = false
    // 削除ボタンを有効にするか切り替える
    @Published var canDeleteMemos = false
    // シート表示管理
    @Published var showSheet = false
    @Published var memoTextEditor = ""
    @Published var canAddMemo = false
    @Published var memoDate = Date()
    // 編集メモを一時的に格納
    var editMemo: Memo!
    // メモを追加する
    func addMemo(content: String, date: Date){
        let newMemo = CoreDataModel.newMemo()
        newMemo.content = content
        newMemo.date = date
        
        CoreDataModel.insert(newMemo)
        CoreDataModel.save()
    }
    // メモを取得する
    func fetchMemos(){
        let fetchedMemos = CoreDataModel.fetchMemos()
        // メモ配列を初期化
        memos = []
        // CoreDataのメモをPublished変数に読み込む
        fetchedMemos.forEach{
            memos.append(MemoModel(isSelected: false, memo: $0))
        }
    }    
    // isSelectedプロパティをfalseにする
    func resetSelectedPropery(){
        for i in 0 ..< memos.count {
            memos[i].isSelected = false
        }
    }
    // メモを削除する
    func deleteMemo() {
        for i in 0 ..< memos.count {
            if memos[i].isSelected {
                CoreDataModel.delete(memos[i].memo)
            }
        }
        CoreDataModel.save()
    }
    // editMemoをnilにリセットする
    func resetEditMemo(){
        editMemo = nil
    }
    
    // メモを更新する
    func updateMemo(viewContext : NSManagedObjectContext, content: String, date: Date) {
        editMemo.content = content
        editMemo.date = date
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("エラー： \(nsError), \(nsError.userInfo)")
        }
    }
    // 入力されたメモをリセットする
    func resetInputedMemo(){
        memoTextEditor = ""
        memoDate = Date()
    }
    
    // メモへのチェックを切り替える
    func toggleMemoForDelete(index i: Int){
        memos[i].isSelected.toggle()
        // メモへのチェックが一つでもある場合は、削除可能状態に切り替える
        for memo in memos{
            canDeleteMemos = false
            if memo.isSelected {
                canDeleteMemos = true
                break
            }
        }
    }
}
