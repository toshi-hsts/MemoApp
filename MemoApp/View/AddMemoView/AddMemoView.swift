//
//  AddMemoView.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/08.
//

import SwiftUI

struct AddMemoView: View {
    // HomeViewModelの環境オブジェクト
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            AddMemoHeaderView()
            AddMemoEditorView()
            AddMemoDateView()
            AddMemoButtonView()
        }
        .background(Color.secondary.opacity(0.3))
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            // キーボードを閉じる
            UIApplication.shared.closeKeyboard()
        }
    }
}
