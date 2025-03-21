// The MIT License (MIT)
//
// Copyright (c) 2020-2024 Alexander Grebenyuk (github.com/kean).

#if os(iOS) || os(visionOS)

import SwiftUI
import CoreData
import Pulse
import Combine
import WatchConnectivity

public struct ConsoleView: View {
    @StateObject private var environment: ConsoleEnvironment // Never reloads
    @Environment(\.presentationMode) private var presentationMode
    private var isCloseButtonHidden = false

    init(environment: ConsoleEnvironment) {
        _environment = StateObject(wrappedValue: environment)
    }

    public var body: some View {
        if #available(iOS 16, *) {
            contents
        } else {
            PlaceholderView(imageName: "xmark.octagon", title: "Unsupported", subtitle: "Pulse requires iOS 16 or later").padding()
        }
    }

    @available(iOS 16, visionOS 1, *)
    private var contents: some View {
        ConsoleListView()
            .navigationTitle(environment.title)
            .foregroundStyle(.black)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    if !isCloseButtonHidden && presentationMode.wrappedValue.isPresented {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .foregroundStyle(Color.black)
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    trailingNavigationBarItems.foregroundStyle(Color.black)
                }
            }
            .injecting(environment)
    }

    /// Changes the default close button visibility.
    public func closeButtonHidden(_ isHidden: Bool = true) -> ConsoleView {
        var copy = self
        copy.isCloseButtonHidden = isHidden
        return copy
    }

    @available(iOS 16, visionOS 1, *)
    @ViewBuilder private var trailingNavigationBarItems: some View {
        Button(action: { environment.router.isShowingShareStore = true }) {
            Image(systemName: "square.and.arrow.up")
        }
        Button(action: { environment.router.isShowingFilters = true }) {
            Image(systemName: "line.horizontal.3.decrease.circle")
        }
        ConsoleContextMenu()
    }
}

#if DEBUG
struct ConsoleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ConsoleView(environment: .init(store: .mock))
            }.previewDisplayName("Console")
            NavigationView {
                ConsoleView(store: .mock, mode: .network)
            }.previewDisplayName("Network")
        }
    }
}
#endif

#endif
