//
//  ContentView.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/06.
//

import SwiftUI

struct HomeView: View {
    // HomeViewModelの環境オブジェクト    
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                // ヘッダ
                HomeHeaderView()
                // メモリスト
                HomeListView()
                // 削除メモ選択中であれば、削除ボタンを表示する
                if homeViewModel.isDeleteMode {
                    // 削除ボタン
                    HomeDeleteButtonView()
                }
            }
            // 削除メモ選択中でなければ、メモ追加ボタンを表示する
            if homeViewModel.isDeleteMode == false {
                HomeAddButtonView()
            }
        }
        // シート表示
        .sheet(isPresented: $homeViewModel.showSheet) {
            AddMemoView()
                .environmentObject(homeViewModel)
        }
        // メモをCoreDataから読み込む
        .onAppear{
            homeViewModel.fetchMemos()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
    }
}
