//
//  AddMemoDateView.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/29.
//

import SwiftUI

struct AddMemoDateView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        // 見出し
        Text("いつのメモ？")
            .font(.title)
            .fontWeight(.bold)
            .padding(.horizontal, 10)
        // 日付入力
        DatePicker("", selection: $homeViewModel.memoDate, displayedComponents: .date)
            .labelsHidden()
            .frame(maxWidth:.infinity, alignment: .center)
            .padding()
            .onAppear{
                // 編集時、テキストエディタに既存日付を代入する
                if homeViewModel.editMemo != nil {
                    homeViewModel.memoDate = homeViewModel.editMemo.date!
                }
            }
    }
}
