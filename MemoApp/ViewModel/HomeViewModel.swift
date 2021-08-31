//
//  HomeViewModel.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/11.
//

import Foundation

class HomeViewModel: ObservableObject {
    // メモ配列
    @Published var memos: [MemoModel] = []
    // メモ削除画面への切り替え
    @Published var isDeleteMode = false
    // 削除ボタンを有効にするか切り替える
    @Published var canDeleteMemos = false
    // シート表示管理
    @Published var showSheet = false
    // メモのテキスト
    @Published var memoTextEditor = ""
    // メモの日付
    @Published var memoDate = Date()
    // 編集メモを一時的に格納
    var editMemo: Memo!
    // CoreDataModelをインスタンス化
    private let coreDataModel = CoreDataModel()
    
    // メモを追加する
    func addMemo(content: String, date: Date){
        let newMemo = coreDataModel.newMemo()
        newMemo.content = content
        newMemo.date = date
        
        coreDataModel.insert(newMemo)
        coreDataModel.save()
    }
    // メモを取得する
    func fetchMemos(){
        let fetchedMemos = coreDataModel.fetchMemos()
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
        canDeleteMemos = false
    }
    // メモを削除する
    func deleteMemo() {
        for i in 0 ..< memos.count {
            if memos[i].isSelected {
                coreDataModel.delete(memos[i].memo)
            }
        }
        coreDataModel.save()
    }
    // 編集メモの初期設定
    func setEditMemo(index: Int){
        editMemo = memos[index].memo
        memoTextEditor = editMemo.content!
        memoDate = editMemo.date!
    }
    // editMemoをnilにリセットする
    func resetEditMemo(){
        editMemo = nil
    }
    
    // メモを更新する
    func updateMemo(content: String, date: Date) {
        editMemo.content = content
        editMemo.date = date
        
        coreDataModel.save()
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
