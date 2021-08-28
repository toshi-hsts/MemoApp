//
//  AddButtonView.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/28.
//

import SwiftUI

struct AddButtonView: View {
    // HomeViewModelの環境オブジェクト
    @EnvironmentObject var homeViewModel: HomeViewModel
    // プラスボタンのグラデーションの定義
    private let plusButtonGradation =  AngularGradient(gradient: Gradient(colors: [.green, .blue, .green]), center: .center, angle: .degrees(-45))
    
    var body: some View {
        Button(action: {
            homeViewModel.showSheet.toggle()
        }) {
            ZStack{
                Circle()
                    .fill(plusButtonGradation)
                    .frame(width: 70, height: 70, alignment: .center)
                Text("＋")
                    .font(.largeTitle)
                    .foregroundColor(.addButtonTextColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.trailing, 30)
    }
}
