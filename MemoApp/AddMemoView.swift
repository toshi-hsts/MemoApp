//
//  AddMemoView.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/08.
//

import SwiftUI

struct AddMemoView: View {
    @State private var memoTextField = ""
    @Binding var showSheet: Bool
    
    // 追加ボタンのグラデーションの定義
    let addMemoButtonGradation = LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        VStack(alignment: .leading){
            Text("メモの追加")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(10)
            
            TextField("", text: $memoTextField)
            
            Spacer()

            // 区切り線
            Divider()
                .padding()
            // 見出し
            Text("いつのメモ？")
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal, 10)
            // date pickerを入れるとこ（仮）
            Text("ここにdate pickerを入れる")
                .frame(maxWidth:.infinity, alignment: .center)
                .padding()
            // 追加ボタン
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(addMemoButtonGradation)
                    .frame(height: 50)
                    .padding()
                Text("+ 追加")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 30)
            .onTapGesture {
                //　メモ登録コードを記載
                print("tapped")
                showSheet.toggle()
            }
        }
        .background(Color.secondary)
        .edgesIgnoringSafeArea(.all)
    }
}

struct AddMemoView_Previews: PreviewProvider {
    static var previews: some View {
        AddMemoView(showSheet: Binding.constant(true))
    }
}
