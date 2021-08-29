//
//  DeleteButton.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/28.
//

import SwiftUI

struct HomeDeleteButtonView: View {
    // HomeViewModelの環境オブジェクト
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        // 削除ボタン
        Button(action: {
            //　メモ削除
            homeViewModel.deleteMemo()
            // メモ読み込み
            homeViewModel.fetchMemos()
            // 削除メモ選択状態を終了する
            homeViewModel.isDeleteMode.toggle()
        }) {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(homeViewModel.canDeleteMemos ? Color.deleteButtonBackgroundColor : Color.deleteButtonBackgroundColor.opacity(0.6))
                    .frame(height: 50)
                    .padding()
                Text("選択したメモを削除")
                    .font(.title2)
                    .foregroundColor(.deleteButtonTextColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom, 30)
        // チェックされた削除メモがないときはボタンを無効化する
        .disabled(homeViewModel.canDeleteMemos == false)
    }
}
