//
//  HeaderView.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/29.
//

import SwiftUI

struct AddMemoHeaderView: View {
    // HomeViewModelの環境オブジェクト
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        Text(homeViewModel.editMemo == nil ? "メモの追加" : "メモの編集")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(10)
    }
}
