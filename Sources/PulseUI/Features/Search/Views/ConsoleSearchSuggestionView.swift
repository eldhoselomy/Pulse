// The MIT License (MIT)
//
// Copyright (c) 2020-2024 Alexander Grebenyuk (github.com/kean).

#if os(iOS) || os(macOS) || os(visionOS)

import SwiftUI
import Pulse
import CoreData
import Combine

@available(iOS 16, visionOS 1, *)
struct ConsoleSearchSuggestionView: View {
    let suggestion: ConsoleSearchSuggestion
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if case .apply = suggestion.action {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.pulse)
                } else {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundColor(.secondary)
                }
                Text(suggestion.text)
                    .lineLimit(1)
                Spacer()
            }
        }
    }
}

struct ShortcutTooltip: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.caption)
            .foregroundColor(.separator)
            .background(Rectangle().frame(width: 34, height: 28).foregroundColor(Color.separator.opacity(0.2)).cornerRadius(8))
    }
}

#endif
