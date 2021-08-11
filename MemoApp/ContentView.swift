//
//  ContentView.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/06.
//

import SwiftUI
//import CoreData

struct ContentView: View {
    //    @Environment(\.managedObjectContext) private var viewContext
    //
    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    //        animation: .default)
    //    private var items: FetchedResults<Item>
    
    // CoreData実装までの仮データ
    @State private var memoArray = ["明日も頑張ろう！明日も頑張ろう！明日も頑張ろう！明日も頑張ろう！","明後日も頑張ろう！明後日も頑張ろう！明後日も頑張ろう！","明明後日も頑張ろう！明明後日も頑張ろう！明明後日も頑張ろう！"]
    
    // シート表示管理
    @State private var showSheet = false
    
    // プラスボタンのグラデーションの定義
    let plusButtonGradation =  AngularGradient(gradient: Gradient(colors: [.green, .blue, .green]), center: .center, angle: .degrees(-45))

    var body: some View {
        ZStack(alignment: .bottomTrailing){
            VStack(alignment: .leading) {
                Text("メモの一覧")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading, 10)
                //　メモがないときの画面表示
                if memoArray.isEmpty {
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
                            ForEach(0 ..< memoArray.count, id: \.self) {
                                Text(memoArray[$0])
                                    .font(.headline)
                                    .padding(.horizontal, 5)
                                Text("日付")
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
            AddMemoView()
        }
    }
    
    //    private func addItem() {
    //        withAnimation {
    //            let newItem = Item(context: viewContext)
    //            newItem.timestamp = Date()
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
    
    //    private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            offsets.map { items[$0] }.forEach(viewContext.delete)
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
}

//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()        
        //        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
