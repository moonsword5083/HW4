//
//  ChartView.swift
//  HW4
//
//  Created by User16 on 2020/5/27.
//  Copyright © 2020 ntou. All rights reserved.
//

import SwiftUI

struct ChartView: View {
    @ObservedObject var charactersData = CharactersData()
    var angles = [Angle]()
    var usefulPercentage: [Double] = [0, 0, 0, 0, 0]
    var usefulSum: [Double] = [0, 0, 0, 0, 0]   //每個分數總共有幾個
    var jobSum: [Double] = [0, 0, 0, 0, 0, 0, 0, 0]   //每個職業總共有幾個
    var jobPercentage: [Double] = [0, 0, 0, 0, 0, 0, 0, 0]   //每個職業百分比(250佔多少)
    var usefulPercentagePresent: [Double] = [0, 0, 0, 0, 0] //顯示在圓餅圖的百分比
    var sum: Double = 0
    @State private var chart = "實用圓餅圖"
    var charts = ["實用圓餅圖", "職業柱狀圖"]
    
    init(charactersData: CharactersData){
        for index in charactersData.characters{
            sum += 1
            usefulSum[index.useful - 1] += 1
            if index.job == "狙擊"{
                jobSum[0] += 1
            }else if index.job == "先鋒"{
                jobSum[1] += 1
            }else if index.job == "醫療"{
                jobSum[2] += 1
            }else if index.job == "術師"{
                jobSum[3] += 1
            }else if index.job == "近衛"{
                jobSum[4] += 1
            }else if index.job == "重裝"{
                jobSum[5] += 1
            }else if index.job == "輔助"{
                jobSum[6] += 1
            }else if index.job == "特種"{
                jobSum[7] += 1
            }
            
        }
        for i in 0..<5{
            usefulPercentage[i] = Double(self.usefulSum[i] / sum)
        }
        var startDegree: Double = 0
        for percentage in usefulPercentage{
            angles.append(.degrees(startDegree))
            startDegree += 360 * percentage
        }
        for i in 0..<5{
            usefulPercentagePresent[i] = self.usefulPercentage[i] * 100
        }
        for i in 0..<8{
            jobPercentage[i] = Double(self.jobSum[i] / sum * 250)
        }
    }
    var body: some View {
        NavigationView{
            VStack{
                Picker(selection: self.$chart, label: Text("圖形")){
                    ForEach(charts, id: \.self){(index) in
                        Text(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .navigationBarTitle("統計圖表")
                if chart == "實用圓餅圖"{
                        if sum == 0{
                            VStack{
                                Image("沒有資料")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300)
                                .clipped()
                                Text("還沒有幹員資料！！！")
                                Text("趕快去添加吧")
                                Spacer()
                            }
                        }else{
                            VStack{
                                Spacer()
                                PieChartView(angles: angles)
                                    .frame(width: 200, height: 200)
                                Spacer()
                                HStack{
                                        Color.yellow.frame(width: 15, height: 15)
                                        Text("1分: \(usefulPercentagePresent[0], specifier: "%.2f")%")
                                        Color.gray.frame(width: 15, height: 15)
                                        Text("2分: \(usefulPercentagePresent[1], specifier: "%.2f")%")
                                }
                                HStack{
                                    Color.green.frame(width: 15, height: 15)
                                    Text("3分: \(usefulPercentagePresent[2], specifier: "%.2f")%")
                                    Color.blue.frame(width: 15, height: 15)
                                    Text("4分: \(usefulPercentagePresent[3], specifier: "%.2f")%")
                                    Color.red.frame(width: 15, height: 15)
                                    Text("5分: \(usefulPercentagePresent[4], specifier: "%.2f")%")
                                }
                                Spacer()
                            }
                        }
                }else if chart == "職業柱狀圖"{
                    if sum == 0{
                        VStack{
                            Image("沒有資料")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                            .clipped()
                            Text("還沒有幹員資料！！！")
                            Text("趕快去添加吧")
                            Spacer()
                        }
                    }else{
                        VStack{
                            Spacer()
                            BarChart(barHeights: jobPercentage)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(charactersData: CharactersData())
    }
}

struct PieChartView: View {
    var angles: [Angle]
    var body: some View{
        ZStack{
            PieChart(startAngle: self.angles[4], endAngle: .zero)
                .fill(Color.red)
            PieChart(startAngle: self.angles[3], endAngle: self.angles[4])
                .fill(Color.blue)
            PieChart(startAngle: self.angles[2], endAngle: self.angles[3])
                .fill(Color.green)
            PieChart(startAngle: self.angles[1], endAngle: self.angles[2])
                .fill(Color.gray)
            PieChart(startAngle: self.angles[0], endAngle: self.angles[1])
                .fill(Color.yellow)
        }
    }
}

struct PieChart: Shape{
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        Path{(path) in
            let center = CGPoint(x: rect.midX, y:rect.midY)
            path.move(to: center)
            path.addArc(center: center, radius: rect.midX, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        }
    }
}

struct BarChart: View
{
    var barHeights: [Double]
    var body: some View
    {
        HStack(spacing: 16)
        {
            Bar(barHeights: self.barHeights[0], info: "狙擊")
            Bar(barHeights: self.barHeights[1], info: "先鋒")
            Bar(barHeights: self.barHeights[2], info: "醫療")
            Bar(barHeights: self.barHeights[3], info: "術師")
            Bar(barHeights: self.barHeights[4], info: "近衛")
            Bar(barHeights: self.barHeights[5], info: "重裝")
            Bar(barHeights: self.barHeights[6], info: "輔助")
            Bar(barHeights: self.barHeights[7], info: "特種")
        }
        .frame(height: 270)
    }
}
struct Bar: View
{
    var barHeights: Double
    @State private var height: CGFloat = 0
    var info: String
    var body: some View
    {
        VStack
        {
            ZStack(alignment: .bottom)
            {
                Capsule().frame(width: 30, height: 250)
                    .foregroundColor(Color(hue: 0.155, saturation: 1.0, brightness: 1.0))
                Capsule().frame(width: 30, height: height)
                    .foregroundColor(Color.orange)
                .animation(.linear(duration:  1))
                .onAppear
                {
                    self.height = CGFloat(self.barHeights)
                }
            }
            Text(info)
            .frame(height: 22)
                .padding(.top, 4)
        }
    }
}
