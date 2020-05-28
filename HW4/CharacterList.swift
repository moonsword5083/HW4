//
//  CharacterList.swift
//  HW4
//
//  Created by User16 on 2020/5/13.
//  Copyright © 2020 00657143. All rights reserved.
//

import SwiftUI

struct CharacterList: View {
    @ObservedObject var charactersData = CharactersData()
    @State private var showEditCharacter = false
    @State private var showAlert = false
    @State private var searchText = ""
    var filterWords: [Character] {
        return charactersData.characters.filter({searchText.isEmpty ? true : $0.name.contains(searchText)})
       }
    var body: some View {
        NavigationView{
            List{
                SearchBar(text: $searchText)
                ForEach(filterWords){(character) in
                    NavigationLink(destination: CharacterEditor(charactersData: self.charactersData, showAlert: self.$showAlert, editCharacter: character)){
                        CharacterRow(character: character)
                    }
                }
                .onMove { (indexSet, index) in
                    self.charactersData.characters.move(fromOffsets: indexSet,
                                    toOffset: index)
                }
                .onDelete{(indexSet) in
                    self.charactersData.characters.remove(atOffsets: indexSet)
                }
            }
            .navigationBarItems(trailing: EditButton())
            .navigationBarTitle("幹員列表")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.showEditCharacter = true
            }, label: {
                Image(systemName: "plus.circle.fill")
                })
                .alert(isPresented: self.$showAlert){ () -> Alert in
                    return Alert(title: Text("已添加過此幹員"))
            }.disabled(charactersData.characters.count == 24)
            )
            .sheet(isPresented: self.$showEditCharacter){
                NavigationView{
                    CharacterEditor(charactersData: self.charactersData, showAlert: self.$showAlert)
                }
            }
        }
    }
}

struct CharacterList_Previews: PreviewProvider {
    static var previews: some View {
        CharacterList(charactersData: CharactersData())
    }
}
