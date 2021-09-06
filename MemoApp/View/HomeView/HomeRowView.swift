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
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading) {
                ForEach(0 ..< homeViewModel.memos.count, id: \.self) { i in
                    VStack(alignment: .leading){
                        HStack{
                            // 削除用のチェックボタンを表示する
                            if homeViewModel.isDeleteMode {
                                Button(action: {
                                    homeViewModel.toggleMemoForDelete(index: i)
                                }) {
                                    Image(systemName: homeViewModel.memos[i].isSelected ? "checkmark.square.fill" : "square")
                                        .padding(.leading, 10)
                                }
                            }
                            // メモの内容と日付を表示
                            VStack(alignment: .leading){
                                Text(homeViewModel.memos[i].memo.content!)
                                    .lineLimit(2)
                                    .font(.headline)
                                    .padding(5)
                                Text(itemFormatter.string(from: homeViewModel.memos[i].memo.date!))
                                    .font(.subheadline)
                                    .padding(.horizontal, 5)
                            }
                        }
                        // 区切り線
                        Divider()
                    }
                    // 行（セル）がタップされたときの処理
                    .contentShape(Rectangle())
                    .onTapGesture{
                        if homeViewModel.isDeleteMode{
                            homeViewModel.toggleMemoForDelete(index: i)
                        } else{
                            homeViewModel.showSheet.toggle()
                            homeViewModel.setEditMemo(index: i)
                        }
                    }
                }
            }
        }
    }
}
