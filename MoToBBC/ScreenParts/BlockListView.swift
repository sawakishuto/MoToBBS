//
//  BlockListView.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/10/20.
//

import SwiftUI
import CoreData

struct BlockListView: View {
    @ObservedObject private var viewModel = ViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: BlockList.entity(),
        sortDescriptors: [NSSortDescriptor(key: "blockList", ascending: false)],
        animation: .default
    ) var fetchedInfomation: FetchedResults<BlockList>
    var body: some View {
        VStack {
            Text("ブロック一覧")
                .foregroundStyle(.red)
                .font(.title)
                .fontWeight(.black)
            if fetchedInfomation.isEmpty {
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
}
    private func fetchedBlockList() {
        if fetchedInfomation.isEmpty {
            return
        } else {
            for value in fetchedInfomation {
                viewModel.blockedList.append(value.blockList ?? "None")
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

#Preview {
    BlockListView()
}
