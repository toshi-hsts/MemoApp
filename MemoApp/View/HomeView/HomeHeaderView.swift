//
//  HeaderView.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/28.
//

import SwiftUI

struct HomeHeaderView: View {
    // HomeViewModelの環境オブジェクト
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        HStack {
            Text("メモの一覧")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.leading, 10)
            // メモがあればメモ削除機能を使えるようにする
            if homeViewModel.memos.isEmpty == false {
                Spacer()
                Button(action: {
                    homeViewModel.isDeleteMode.toggle()
                    // チェックボックスの入力をリセットする
                    if homeViewModel.isDeleteMode == false {
                        homeViewModel.resetSelectedPropery()
                    }
                }) {
                    Image(systemName: homeViewModel.isDeleteMode ? "clear" : "trash")
                        .foregroundColor(.primary)
                        .font(.title2)
                        .padding(.trailing, 20)
                }
            }
        }
    }
}
