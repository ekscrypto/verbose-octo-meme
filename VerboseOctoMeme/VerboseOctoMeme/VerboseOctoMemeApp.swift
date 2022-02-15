//
//  VerboseOctoMemeApp.swift
//  VerboseOctoMeme
//
//  Created by Dave Poirier on 2022-02-14.
//  Copyrights (c) Dave Poirier 2022.  Distributed under MIT License.
//

import SwiftUI

@main
struct VerboseOctoMemeApp: App {

    var body: some Scene {
        WindowGroup {
            Injector.constructRootView()
        }
    }
}
