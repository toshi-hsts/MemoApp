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
    // メモ削除画面への切り替え
    @State var isSelectingDeleteMemo = false
    // シート表示管理
    @State private var showSheet = false
    // プラスボタンのグラデーションの定義
    let plusButtonGradation =  AngularGradient(gradient: Gradient(colors: [.green, .blue, .green]), center: .center, angle: .degrees(-45))
    // 日付を指定書式に変換する
    let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        formatter.dateFormat = "yyyy年MM月d日(EEEEE)"
        return formatter
    }()
    // HomeViewModelのインスタンス生成
    @ObservedObject private var homeViewModel = HomeViewModel()
    
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
                            isSelectingDeleteMemo.toggle()
                        }) {
                            Image(systemName: isSelectingDeleteMemo ? "clear" : "trash")
                                .foregroundColor(.black)
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
                            ForEach(0 ..< homeViewModel.memos.count) { i in
                                VStack(alignment: .leading){
                                    HStack{
                                        // 削除メモ選択中は、チェックボタンを表示する
                                        if isSelectingDeleteMemo {
                                            Button(action: {
                                                homeViewModel.memos[i].isSelected.toggle()
                                            }) {
                                                Image(systemName: homeViewModel.memos[i].isSelected ? "checkmark.square.fill" : "square")
                                                    .padding(.leading, 10)
                                            }
                                        }
                                        // メモの内容と日付を表示
                                        VStack(alignment: .leading){
                                            Text(homeViewModel.memos[i].memo.content!)
                                                .font(.headline)
                                                .padding(.horizontal, 5)
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
                                    if isSelectingDeleteMemo{
                                        homeViewModel.memos[i].isSelected.toggle()
                                    }
                                }
                            }
                        }
                    }
                }
                // 削除メモ選択中であれば、削除ボタンを表示する
                if isSelectingDeleteMemo {
                    // 削除ボタン
                    Button(action: {
                        //　メモ削除
                        homeViewModel.deleteMemo(viewContext: viewContext)
                        // 削除メモ選択状態を終了する
                        isSelectingDeleteMemo.toggle()
                    }) {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.red)
                                .frame(height: 50)
                                .padding()
                            Text("選択したメモを削除")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 30)
                }
            }
            // 削除メモ選択中でなければ、メモ追加ボタンを表示する
            if isSelectingDeleteMemo == false {
                Button(action: {
                    showSheet.toggle()
                }) {
                    ZStack{
                        Circle()
                            .fill(plusButtonGradation)
                            .frame(width: 70, height: 70, alignment: .center)
                        Text("＋")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 30)
            }
        }
        // シート表示
        .sheet(isPresented: $showSheet) {
            AddMemoView(homeViewModel: homeViewModel)
        }
        // メモをCoreDataから読み込む
        .onAppear{
            homeViewModel.loadMemos(viewContext: viewContext)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
