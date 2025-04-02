import SwiftUI
import CoreTransferable
import UniformTypeIdentifiers

extension Array: @retroactive Transferable where Element == CGPoint {
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .plainText) { value in
            let string = value.map { "(\($0.x),\($0.y))" }.joined(separator: "\n")
            return string.data(using: .utf8)!
        }
    }
}


struct CopyButton<T: Transferable>: View {
    var item: T

    var body: some View {
        Button("Copy") {
            Task {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                let pasteboardItem = NSPasteboardItem()
                for type in item.exportedContentTypes() {
                    if let data = try? await item.exported(as: type) {
                        pasteboardItem.setData(data, forType: NSPasteboard.PasteboardType(type.identifier))
                        if type.conforms(to: .plainText) {
                            let string = String(data: data, encoding: .utf8)
                            pasteboardItem.setString(string ?? "", forType: .string)
                        }
                    }
                }
                pasteboard.writeObjects([pasteboardItem])
            }
        }
    }
}


struct Identified <ID, Value>: Identifiable where ID: Hashable {
    var id: ID
    var value: Value
}

extension Collection {
    func identifiedByIndex() -> [Identified<Int, Element>] {
        enumerated().map { Identified(id: $0, value: $1) }
    }
}

