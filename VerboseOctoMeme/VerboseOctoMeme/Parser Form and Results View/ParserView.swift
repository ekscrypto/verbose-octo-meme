//
//  ParserView.swift
//  VerboseOctoMeme
//
//  Created by Dave Poirier on 2022-02-14.
//  Copyrights (c) Dave Poirier 2022.  Distributed under MIT License.
//
//  PURPOSE: Root screen of the app, includes the user entry form and output results

import SwiftUI

struct ParserView<Parser: ParserCompatible>: View {
    
    let initialInputText: String
    @ObservedObject var viewModel: ParserViewModel<Parser>
    
    var body: some View {
        return ScrollView {
            FormView(
                inputString: initialInputText,
                parseAction: { viewModel.parse($0) },
                parserLoading: !viewModel.parserReady)
                .padding()
            
            if !viewModel.parserReady {
                Text("Loading dictionary…")
            }
            
            if viewModel.parserBusy {
                Text("Parsing…")
            }
            
            if let text = viewModel.parsedText {
                ResultsView(
                    parsedText: text,
                    identifiedWords: Array(viewModel.identifiedWords))
            }
            
            Spacer()
        }
    }
}

struct ParserView_Previews: PreviewProvider {
    
    private class NeverLoadedParser: ParserCompatible {
        @Published private(set) var ready: Bool = false
        var readyPublisher: Published<Bool>.Publisher { $ready }
        
        func parse(_ value: String, result: @escaping (Set<DictionaryEntry>) -> Void) -> Thread {
            fatalError("Never used")
        }
    }
    
    private class AlwaysLoadedParser: ParserCompatible {
        @Published private(set) var ready: Bool = true
        var readyPublisher: Published<Bool>.Publisher { $ready }

        func parse(_ value: String, result: @escaping (Set<DictionaryEntry>) -> Void) -> Thread {
            fatalError("Never used")
        }
    }

    static var previews: some View {
        ParserView<NeverLoadedParser>(
            initialInputText: "",
            viewModel: ParserViewModel<NeverLoadedParser>(
                parser: NeverLoadedParser()))
            .previewDisplayName("App start loading state")

        ParserView<AlwaysLoadedParser>(
            initialInputText: "Hello World",
            viewModel: ParserViewModel<AlwaysLoadedParser>(
                parser: AlwaysLoadedParser()))
            .previewDisplayName("Dictionary still loading, user entered text")

        ParserView<AlwaysLoadedParser>(
            initialInputText: "Hello World",
            viewModel: ParserViewModel<AlwaysLoadedParser>(
                parser: AlwaysLoadedParser()))
            .previewDisplayName("Dictionary loaded, waiting for user to tap parse")

        ParserView<AlwaysLoadedParser>(
            initialInputText: "",
            viewModel: ParserViewModel<AlwaysLoadedParser>(
                parser: AlwaysLoadedParser()))
            .previewDisplayName("Dictionary loaded, no text entered by user")
    }
}
