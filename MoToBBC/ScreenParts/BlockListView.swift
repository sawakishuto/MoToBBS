import SwiftUI
import CoreData

struct BlockListView: View {
    @ObservedObject private var viewModel = DatasModel()
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: BlockList.entity(),
        sortDescriptors: [NSSortDescriptor(key: "blockList", ascending: false)],
        animation: .default
    ) var fetchedInfomation: FetchedResults<BlockList>
    
    @State private var dataLoaded = false
    
    var body: some View {
        VStack {
            if !dataLoaded {
                ProgressView() // データが読み込まれるまでのメッセージ
            } else if fetchedInfomation.isEmpty {
                Text("ブロックしているユーザーはいません")
            } else {
                List {
                    ForEach(fetchedInfomation) { value in
                        Text(value.blockList ?? "")
                    }
                    .onDelete(perform: deleteBlock)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                self.dataLoaded = true
            }
        }
    }
    
    private func deleteBlock(offsets: IndexSet) {
        offsets.forEach { index in
            viewContext.delete(fetchedInfomation[index])
        }
        // 保存を忘れない
        try? viewContext.save()
    }
}
