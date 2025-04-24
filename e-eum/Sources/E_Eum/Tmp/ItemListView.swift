import SwiftUI

struct ItemListView: View {
    @Environment(ViewModel.self) var viewModel: ViewModel

    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                NavigationLink(value: item) {
                    Label {
                        Text(item.itemTitle)
                    } icon: {
                        if item.favorite {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                        }
                    }
                }
            }
            .onDelete { offsets in
                viewModel.items.remove(atOffsets: offsets)
            }
            .onMove { fromOffsets, toOffset in
                viewModel.items.move(fromOffsets: fromOffsets, toOffset: toOffset)
            }
        }
        .navigationDestination(for: Item.self) { item in
            ItemView(item: item)
                .navigationTitle(item.itemTitle)
        }
        .toolbar {
            ToolbarItemGroup {
                Button {
                    withAnimation {
                        viewModel.items.insert(Item(), at: 0)
                    }
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
    }
}
