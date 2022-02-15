//
//  FormView.swift
//  VerboseOctoMeme
//
//  Created by Dave Poirier on 2022-02-14.
//  Copyrights (c) Dave Poirier 2022.  Distributed under MIT License.
//
//  PURPOSE: Contains the input field & parse buttons for the user data entry


import SwiftUI

struct FormView: View {
    
    @State var inputString: String = ""
    let parseAction: (String) -> Void
    let parserLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter a string to parse:")
            TextField("Input", text: $inputString)
                .padding(.horizontal, 0).padding(.top, 20)
                .accessibilityIdentifier("UserInputField")
            Divider()
            HStack {
                Spacer()
                Button("Parse", action: {
                    parseAction(inputString)
                })
                    .disabled(parserLoading || inputString.isEmpty)
                    .padding()
                    .border(.ultraThickMaterial)
                    .accessibilityIdentifier("ParseButton")
            }
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView(inputString: "", parseAction: { _ in }, parserLoading: true)
            .previewDisplayName("Empty String, parser not ready")
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/340.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/200.0/*@END_MENU_TOKEN@*/))
                .padding()
        
        FormView(inputString: "", parseAction: { _ in }, parserLoading: false)
            .previewDisplayName("Empty String, parser ready")
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/340.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/200.0/*@END_MENU_TOKEN@*/))
                .padding()

        FormView(inputString: "Hello World", parseAction: { _ in }, parserLoading: true)
            .previewDisplayName("Text defined, parser not ready")
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/340.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/200.0/*@END_MENU_TOKEN@*/))
                .padding()

        FormView(inputString: "Hello World", parseAction: { _ in }, parserLoading: false)
            .previewDisplayName("Text defined, parser ready")
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/340.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/200.0/*@END_MENU_TOKEN@*/))
                .padding()
    }
}
