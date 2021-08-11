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
        ZStack(alignment: .bottomTrailing){
            VStack(alignment: .leading) {
                Text("メモの一覧")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading, 10)
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
                            ForEach(homeViewModel.memos) { memo in
                                Text(memo.content!)
                                    .font(.headline)
                                    .padding(.horizontal, 5)
                                Text(itemFormatter.string(from: memo.date!))
                                    .font(.subheadline)
                                    .padding(.horizontal, 5)
                                // 区切り線
                                Divider()
                            }
                        }
                    }
                }
            }
            // メモ登録シートを表示するボタン
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
                .offset(x: -30.0, y: -30.0)
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
