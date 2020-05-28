//
//  CharacterEditor.swift
//  HW4
//
//  Created by User16 on 2020/5/13.
//  Copyright © 2020 00657143. All rights reserved.
//

import SwiftUI

struct CharacterEditor: View {
    @Environment(\.presentationMode) var presentationMode
    var charactersData = CharactersData()
    @State private var name = "W"
    var character = ["W", "伊芙利特", "安潔莉娜", "年", "艾雅法拉", "刻俄柏", "夜鶯", "阿", "星熊", "風笛", "能天使", "閃靈", "推進之王", "莫斯提馬", "陳", "麥哲倫", "傀影", "斯卡蒂", "温蒂", "黑", "塞雷婭", "煌", "赫拉格", "銀灰"]
    @State private var job = "狙擊"
    var occupation = ["狙擊", "先鋒", "醫療", "術師", "近衛", "重裝", "輔助", "特種"]
    @State private var useful = 3
    @State private var favourite = true
    @Binding var showAlert:Bool
    @State private var sameCharacter = false
    var editCharacter: Character?
    
    var body: some View {
        Form{
            VStack{
                Image("\(name)_2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .clipped()
                Picker(selection: self.$name, label: Text("幹員")){
                    ForEach(character, id: \.self){(index) in
                        Text(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            Picker(selection: self.$job, label: Text("職業")){
                ForEach(occupation, id: \.self){(index) in
                    Text(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            Stepper("實用分數\(useful) 分", value: $useful,in: 1...5)
            Toggle("我的最愛", isOn: $favourite)
        }
        .navigationBarTitle(editCharacter == nil ? "新增幹員" : "編輯幹員資料")
        .navigationBarItems(trailing: Button("儲存"){
            let character = Character(name: self.name, useful: self.useful, favourite: self.favourite, job: self.job)
            //判斷要新增幹員還是修改幹員資料
            if let editCharacter = self.editCharacter{
                //找出幹員在array裡的位置
                let index = self.charactersData.characters.firstIndex{
                    $0.id == editCharacter.id
                }!
                for nowCharacter in self.charactersData.characters.indices{
                    if nowCharacter != index {
                        if self.charactersData.characters[nowCharacter].name == character.name{
                            self.showAlert = true
                            self.sameCharacter = true
                            break
                        }
                    }
                }
                if self.sameCharacter == false{
                    self.charactersData.characters[index] = character
                }
            }else{
                for nowCharacter in self.charactersData.characters.indices{
                    if self.charactersData.characters[nowCharacter].name == character.name{
                        self.showAlert = true
                        self.sameCharacter = true
                        break
                    }
                }
                if self.sameCharacter == false{
                    self.charactersData.characters.insert(character, at: 0)
                }
            }
            self.presentationMode.wrappedValue.dismiss()
        })
        //觸發畫面更新，讓畫面顯示幹員的資料
        .onAppear{
            if let editCharacter = self.editCharacter{
                self.name = editCharacter.name
                self.useful = editCharacter.useful
                self.favourite = editCharacter.favourite
            }
        }
    }
}

struct CharacterEditor_Previews: PreviewProvider {
    static var previews: some View {
        CharacterEditor(charactersData: CharactersData(),showAlert: .constant(false))
    }
}
