//
//  AppView.swift
//  HW4
//
//  Created by User16 on 2020/5/27.
//  Copyright © 2020 ntou. All rights reserved.
//

import SwiftUI

struct AppView: View {
    @ObservedObject var charactersData = CharactersData()
    var body: some View {
        TabView{
            CharacterList(charactersData: self.charactersData)
                .tabItem{
                    Image(systemName: "person.circle")
                    Text("幹員列表")
            }
            ChartView(charactersData: self.charactersData)
                .tabItem{
                    Image(systemName: "chart.pie")
                    Text("統計圖表")
            }
        }
        .accentColor(.orange)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
