//
//  AddMemoView.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/08.
//

import SwiftUI
import CoreData

struct AddMemoView: View {
    @State private var memoTextEditor = ""
    @State private var canAddMemo = false
    @State private var memoDate = Date()
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    // HomeViewModelインスタンスを定義
    private let homeViewModel: HomeViewModel
    // 追加ボタンのグラデーションの定義
    private let enableAddMemoButtonGradation = LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .leading, endPoint: .trailing)
    // 追加ボタンのグラデーションの定義(非活性ver)
    private let disableAddMemoButtonGradation = LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.5), .green.opacity(0.5)]), startPoint: .leading, endPoint: .trailing)
    // 構造体の初期化
    init(homeViewModel: HomeViewModel) {
        // TextEditorの背景色を透過させる
        UITextView.appearance().backgroundColor = .clear
        // 親ViewのviewModel参照を受け取る
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text(homeViewModel.editMemo == nil ? "メモの追加" : "メモの編集")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(10)
            // メモ入力欄
            TextEditor(text: $memoTextEditor)
                .onChange(of: memoTextEditor) { _ in
                    // 入力文字数が空であれば、メモを追加できないようにする
                    canAddMemo = !memoTextEditor.isEmpty
                }
                .onAppear{
                    // 編集時、テキストエディタに既存メモを代入する
                    if homeViewModel.editMemo != nil {
                        memoTextEditor = homeViewModel.editMemo.content!
                    }
                }
            // 区切り線
            Divider()
                .padding()
            // 見出し
            Text("いつのメモ？")
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal, 10)
            // 日付入力
            DatePicker("", selection: $memoDate, displayedComponents: .date)
                .labelsHidden()
                .frame(maxWidth:.infinity, alignment: .center)
                .padding()
            // 追加・更新ボタン
            Button(action: {
                if homeViewModel.editMemo == nil{
                    //　メモ登録
                    homeViewModel.addMemo(viewContext: viewContext, content: memoTextEditor, date: memoDate)
                } else{
                    //　メモ更新
                    homeViewModel.updateMemo(viewContext: viewContext, content: memoTextEditor, date: memoDate)
                    // 編集メモをnilにリセットする
                    homeViewModel.resetEditMemo()
                }
                // シートを閉じる
                presentationMode.wrappedValue.dismiss()
            }) {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(canAddMemo ? enableAddMemoButtonGradation : disableAddMemoButtonGradation)
                        .frame(height: 50)
                        .padding()
                    Text(homeViewModel.editMemo == nil ? "+  追加" : "+  更新")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 30)
            // メモの中身がないときは追加ボタンを無効化する
            .disabled(canAddMemo == false)
        }
        .background(Color.secondary.opacity(0.3))
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            // キーボードを閉じる
            UIApplication.shared.closeKeyboard()
        }
        .onDisappear{
            // 編集メモをnilにリセットする
            if homeViewModel.editMemo != nil {
                homeViewModel.resetEditMemo()
            }
        }
    }
}

extension UIApplication {
    // キーボードを閉じる
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct AddMemoView_Previews: PreviewProvider {
    static var previews: some View {
        AddMemoView(homeViewModel: HomeViewModel())
    }
}
