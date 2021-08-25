//
//  ContentView.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/06.
//

import SwiftUI
import CoreData

struct HomeView: View {
    // managedObjectContextをviewContextとして定義
    @Environment(\.managedObjectContext) private var viewContext
    // HomeViewModelのインスタンス生成
    @StateObject private var homeViewModel = HomeViewModel()
    // プラスボタンのグラデーションの定義
    private let plusButtonGradation =  AngularGradient(gradient: Gradient(colors: [.green, .blue, .green]), center: .center, angle: .degrees(-45))
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
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading) {
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
                                        homeViewModel.editMemo = homeViewModel.memos[i].memo
                                    }
                                }
                            }
                        }
                    }
                }
                // 削除メモ選択中であれば、削除ボタンを表示する
                if homeViewModel.isDeleteMode {
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
            // 削除メモ選択中でなければ、メモ追加ボタンを表示する
            if homeViewModel.isDeleteMode == false {
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
        // シート表示
        .sheet(isPresented: $homeViewModel.showSheet) {
            AddMemoView(homeViewModel: homeViewModel)
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
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
