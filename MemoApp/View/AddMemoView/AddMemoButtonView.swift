//
//  AddMemoButtonView.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/29.
//

import SwiftUI

struct AddMemoButtonView: View {
    @Environment(\.presentationMode) private var presentationMode
    // HomeViewModelの環境オブジェクト
    @EnvironmentObject var homeViewModel: HomeViewModel
    // 追加ボタンのグラデーションの定義
    private let enableAddMemoButtonGradation = LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .leading, endPoint: .trailing)
    // 追加ボタンのグラデーションの定義(非活性ver)
    private let disableAddMemoButtonGradation = LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.5), .green.opacity(0.5)]), startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        // 追加・更新ボタン
        Button(action: {
            if homeViewModel.editMemo == nil{
                //　メモ登録
                homeViewModel.addMemo(content: homeViewModel.memoTextEditor, date: homeViewModel.memoDate)
            } else{
                //　メモ更新
                homeViewModel.updateMemo(content: homeViewModel.memoTextEditor, date: homeViewModel.memoDate)
                // 編集メモをnilにリセットする
                homeViewModel.resetEditMemo()
            }
            // メモ読み込み
            homeViewModel.fetchMemos()
            // シートを閉じる
            presentationMode.wrappedValue.dismiss()
        }) {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(homeViewModel.memoTextEditor.isEmpty ? disableAddMemoButtonGradation : enableAddMemoButtonGradation)
                    .frame(height: 50)
                    .padding()
                Text(homeViewModel.editMemo == nil ? "+  追加" : "+  更新")
                    .font(.title2)
                    .foregroundColor(.addButtonTextColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom, 30)
        // メモの中身がないときは追加ボタンを無効化する
        .disabled(homeViewModel.memoTextEditor.isEmpty)
        
    }
}
