//
//  RowView.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/28.
//

import SwiftUI

struct HomeRowView: View {
    // HomeViewModelの環境オブジェクト
    @EnvironmentObject var homeViewModel: HomeViewModel
    // 索引
    let index: Int
    // 日付を指定書式に変換する
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        formatter.dateFormat = "yyyy年MM月d日(EEEEE)"
        return formatter
    }()
    
    var body: some View {
        // メモ数未満のindexだけ表示する（削除時のエラー対策）
        if index < homeViewModel.memos.count {
            VStack(alignment: .leading){
                HStack{
                    // 削除用のチェックボタンを表示する
                    if homeViewModel.isDeleteMode {
                        Button(action: {
                            homeViewModel.toggleMemoForDelete(index: index)
                        }) {
                            Image(systemName: homeViewModel.memos[index].isSelected ? "checkmark.square.fill" : "square")
                                .padding(.leading, 10)
                        }
                    }
                    // メモの内容と日付を表示
                    VStack(alignment: .leading){
                        Text(homeViewModel.memos[index].memo.content!)
                            .lineLimit(2)
                            .font(.headline)
                            .padding(5)
                        Text(itemFormatter.string(from: homeViewModel.memos[index].memo.date!))
                            .font(.subheadline)
                            .padding(.horizontal, 5)
                    }
                }
                // 区切り線
                Divider()
            }
        }
    }
}
