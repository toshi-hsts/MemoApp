//
//  AddMemoEditorView.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/29.
//

import SwiftUI

struct AddMemoEditorView: View {
    // HomeViewModelの環境オブジェクト
    @EnvironmentObject var homeViewModel: HomeViewModel
    // 構造体の初期化
    init() {
        // TextEditorの背景色を透過させる
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        // メモ入力欄
        TextEditor(text: $homeViewModel.memoTextEditor)
        // 区切り線
        Divider()
            .padding()
    }
}
