//
//  WordScrollView.swift
//  MemorizeIt
//
//  Created by David Hendren on 3/24/20.
//  Copyright © 2020 David Hendren. All rights reserved.
//

import SwiftUI

struct WordScrollView: View {
    var body: some View {
        NavigationView{
            VStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                NavigationLink(destination: ContentView()){
                    Text("Go back!")
                }
            }
            .navigationBarTitle("Word Quiz")
        }
    }
}

struct WordScrollView_Previews: PreviewProvider {
    static var previews: some View {
        WordScrollView()
    }
}
