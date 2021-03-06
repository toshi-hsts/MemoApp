//
//  ListView.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/28.
//

import SwiftUI

struct HomeListView: View {
    // HomeViewModelの環境オブジェクト
    @EnvironmentObject var homeViewModel: HomeViewModel

    var body: some View {
        //　メモがないときの画面表示
        if homeViewModel.memos.isEmpty {
            ZStack {
                Spacer()
                    .frame(maxWidth: .infinity)
                    .background(Color.secondary.opacity(0.3))
                    .edgesIgnoringSafeArea(.all)
                Text("なし")
                    .font(.title)
                    .fontWeight(.bold)
            }
            //　メモがあるときの画面表示
        } else {
            HomeRowView()
        }
    }
}
