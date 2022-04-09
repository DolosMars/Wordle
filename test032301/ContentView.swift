//
//  ContentView.swift
//  test032301
//
//  Created by User06 on 2022/3/23.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("date") var LastGame: Double = 0
    @State var remainingTime: Int = 300 //設定秒數
    
    @State private var gameView = false
    
    @State var letters: Double = 5
    @State private var playTimes: Double = 6
    
    @State private var showAlert = false
    @State private var showSorryAlert = false
    @State private var showSecondView = false
    

    var body: some View {
        VStack {
            //標題
            Text("Wordle by русский")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 50.0)
                .offset(x: 0, y: -50)
            
            
            //選擇有幾個字母及次數
            Group{
                VStack{
                    Text("Letters:\(Int(letters))")
                        .padding(.bottom,-15)
                    Slider(value: $letters, in: 4...6, step: 1, minimumValueLabel: Text("4"), maximumValueLabel: Text("6")){}
                    Text("Times:\(Int(playTimes))")
                        .padding(.bottom,-15)
                    Slider(value: $playTimes, in: 3...7, step: 1, minimumValueLabel: Text("3"), maximumValueLabel: Text("7")){
                    }
                }.frame(width: 200, height: 0, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Button {
                    
                    let time1 = Date(timeIntervalSince1970: LastGame)
                    let time2 = Date()
                    let components = Calendar.current.dateComponents([.second], from: time1, to:time2)
                    if(remainingTime-Int(components.second!)<0){
                        gameView = true
                        remainingTime = 300 //設定秒數
                    }else{
                        showAlert = true
                        remainingTime = remainingTime-Int(components.second!)
                        
                    }
                    LastGame = Date().timeIntervalSince1970
                    
                } label: {
                    VStack{
                        Text("Play")
                    Image(systemName: "arrowtriangle.right")
                        .font(.system(size: 50))
                    }
                }.offset(x: 0, y: 65)
                .sheet(isPresented: $gameView) {
                    game(letters: letters, playTimes: playTimes)}
                .alert(isPresented: $showAlert, content: {
                         return Alert(title: Text("\(remainingTime / 60)min \(remainingTime %  60)sec"))
                     })
                
                
                
            }
            
            HStack{
                //提示
                Button {
                    showSecondView = true
                    //need to do
                } label: {
                    VStack{
                        Text("hint")
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 30))
                    }
                    
                }.sheet(isPresented: $showSecondView) {
                    SecondView()
                }
                
                
                //提示跟單字本中間的空隙
                Spacer()
                    .frame(width: 50)
                    .background(Color.yellow)
                
                //單字本
                Button {
                    showSorryAlert = true
                    //need to do
                } label: {
                    VStack{
                        Text("Saved")
                        Image(systemName: "bookmark")
                            .font(.system(size: 30))
                    }
                    
                }}.padding(30)
                .offset(x: 0, y: 60)
                .alert(isPresented: $showSorryAlert, content: {
                         return Alert(title: Text("Not completed"),message: Text("I'm sorry about that. ><"))
                     })
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SecondView: View {
    var body: some View {
        VStack {
            Text("HOW TO PLAY")
                .bold()
                .font(.system(size: 30))
            Text("")
            
            HStack{
                Text("Guess the")
                Text(" WORDLE ")
                    .bold()
                Text("in limited tries.")
            }
            VStack{
            Text("")
            Text("Each guess must be a valid word.")
            Text("Hit the enter button to submit.")
            Text("")
            Text("After each guess, the color of the tiles will change to show how close your guess was to the word.")
            }
            VStack{
            Divider()
            Text("Example")
                Image("1")
                Text("The letter д is in the word and in the correct spot.")
                Image("2")
                Text("The letter p is in the word but in the wrong spot.")
                Image("3")
                Text("All the letter is not in the word in any spot.")
            Divider()
            }
            
        }.padding(20)
    }
}
