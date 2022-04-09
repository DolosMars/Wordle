//
//  game.swift
//  test032301
//
//  Created by User06 on 2022/3/23.
//

import SwiftUI

struct word {
    let letter: String
    let color: Int = 0
    let number: Int
    //no color:0, wrong:1, half:2, true:3
}

struct keyboard {
    let keyboardLetter: String
    var color: Int = 0
}

struct game: View {
    @State private var RussianLetter = ["ё","й","ц","у","к","е","н","г","ш","щ","з","х","б","ф","ы","в","а","п","р","о","л","д","ж","э","я","ч","с","м","и","т","ь","ъ","ю"]
    @State private var  RussianColor = Array(repeating: 0, count: 33)
    @State private var  guessWord = Array(repeating: "", count: 42)
    @State private var  guessColor = Array(repeating: 0, count: 42)
    @State private var array = [Substring]()
    @State private var count: Int = 0
    
    @State private var showSecondView = false
    //@State private var guessWord = [word]()
    //@State private var guessWord = [word(letter: "a", number: 0)]
    //0: gray 1:falseColor 2:falsePlaceColor 3:trueColor
    @State private var wordle = []
    
    @State private var generalColor = Color.gray
    @State private var trueColor = Color.green
    @State private var falsePlaceColor = Color.yellow
    @State private var falseColor = Color.red
    @State private var wordColor = Color.white
    
    @State var letters: Double
    @State var playTimes: Double
    @State var forward: Int = 0 //到哪個
    @State var row: Int = 0 //到哪行
    @State var countWord: Int = 0
    @State var cantInput: Bool = false
    @State private var randomWord = ""
    @State private var guess = ""
    @State private var inList = false
    @State private var trueWord = false
    
    @State private var showAlert = false
    @State private var Alertcase = 0
    
    //@State private var createKeyboard = [keyboard]()
    /*@State private var createKeyboard:[keyboard] = {
     var createKeyboard = [keyboard]()
     for i in RussianLetter.indices{
     let item = keyboard(keyboardLetter: RussianLetter[i])
     createKeyboard.append(item)
     }
     return createKeyboard
     }()*/
    func type(i:Int) {
        if (countWord < Int(letters)){
            guessWord[forward] =  RussianLetter[i]
            forward += 1
            countWord += 1
            count += 1
            if (count == Int(letters))
            {
                cantInput = true
            }
            
        }
    }
    
    
    
    var body: some View {
        VStack{
            Text("Wordle by русский")
                .font(.system(size: 25))
                .foregroundColor(generalColor)
            //畫方格
            //VStack{
            ForEach(0..<Int(playTimes)){row in
                //Int(playTimes)
                HStack{
                    ForEach(0..<Int(letters)){col in
                        if (letters < 7){
                            //print(row*Int(letters)+col)
                            //row*Int(letters)+col >= guessWord.count
                            if(guessWord[row*Int(letters)+col]==""){
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(generalColor, lineWidth: 5)
                                    .frame(width: 30, height: 40)}
                            else{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(guessColor[row*Int(letters)+col] == 0 ? generalColor : guessColor[row*Int(letters)+col] == 1 ? falseColor : guessColor[row*Int(letters)+col] == 2 ? falsePlaceColor : trueColor)
                                        .frame(width: 30, height: 40)
                                    
                                    Text(guessWord[row*Int(letters)+col])
                                        .font(.system(size: 25))
                                        .foregroundColor(wordColor)
                                    
                                }}
                            
                        }
                        /* else if(letters >= 7){
                         if (row*Int(letters)+col >= guessWord.count){
                         Rectangle()
                         .stroke(Color.gray, lineWidth: 5)
                         .frame(width: 30, height: 50)
                         }
                         else{
                         Rectangle()
                         .fill(Color.gray)
                         
                         .frame(width: 40, height: 50)
                         }
                         }*/
                    }
                }
            }
            /*}.offset( y: -200)
             .padding(.bottom, -100.0)*/
            //鍵盤
            VStack{
                HStack{
                    //鍵盤第一排
                    ForEach(0..<13){i in
                        Button{
                            type(i:i)
                        } label : {
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(RussianColor[i] == 0 ? generalColor :RussianColor[i] == 1 ? falseColor : RussianColor[i] == 2 ? falsePlaceColor : trueColor)
                                    .frame(width: 20, height: 30)
                                    .padding(.leading, -4)
                                Text(RussianLetter[i])
                                    .padding(.leading, -4)
                                    .foregroundColor(wordColor)
                                
                            }}.disabled(cantInput)
                    }
                }
                HStack{
                    //鍵盤第二排
                    ForEach(13..<24){i in
                        Button{
                            type(i:i)
                        } label : {
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(RussianColor[i] == 0 ? generalColor :RussianColor[i] == 1 ? falseColor : RussianColor[i] == 2 ? falsePlaceColor : trueColor)
                                    .frame(width: 20, height: 30)
                                    .padding(.leading, -4)
                                Text(RussianLetter[i])
                                    .padding(.leading, -4)
                                    .foregroundColor(wordColor)
                                
                            }}.disabled(cantInput)
                    }
                }
                HStack{
                    //鍵盤第三排
                    //Enter
                    Button{
                        print("forward:\(forward) count:\(countWord)")
                        guess = "" //猜的字串
                        inList = false
                        if (countWord == Int(letters))
                        {
                            count = 0
                            cantInput = false
                            
                            for i in 0..<Int(letters)
                            {
                                guess += guessWord[row+i]
                            }
                            for i in array.indices {
                                if (guess == array[i])//在list裡
                                {
                                    countWord = countWord - Int(letters)
                                    inList = true
                                    if (randomWord == guess) //猜中
                                    {
                                        print("恭喜")
                                        showAlert = true
                                        Alertcase = 1
                                        for i in 0..<Int(letters)
                                        {
                                            guessColor[row+i] = 3
                                        }
                                        for m in guess.indices{
                                            for p in RussianLetter.indices{
                                                //print(RussianLetter[p])
                                                if(String(guess[m]) == String(RussianLetter[p]))
                                                {
                                                    RussianColor[p] = 3
                                                }
                                            }}
                                        cantInput = true
                                    }
                                    else{
                                        var tempPosition = 0
                                        
                                        for m in guess.indices{
                                            trueWord = false
                                            for n in randomWord.indices {
                                                if(guess[m] == randomWord[n]){
                                                    if (m==n){ //字對了 位置對了
                                                        guessColor[row+tempPosition] = 3
                                                        for p in RussianLetter.indices{
                                                            //print(RussianLetter[p])
                                                            if(String(guess[m]) == String(RussianLetter[p]))
                                                            {
                                                                RussianColor[p] = 3
                                                            }
                                                        }
                                                        trueWord = true
                                                        break
                                                    }
                                                    else{   //字對了 位置不對
                                                        guessColor[row+tempPosition] = 2
                                                        for p in RussianLetter.indices{
                                                            //print(RussianLetter[p])
                                                            if(String(guess[m]) == String(RussianLetter[p]))
                                                            {
                                                                RussianColor[p] = 2
                                                            }
                                                        }
                                                        trueWord = true
                                                    }
                                                }
                                            }
                                            if (trueWord == false){ //沒猜中
                                                guessColor[row+tempPosition] = 1
                                                for p in RussianLetter.indices{
                                                    //print(RussianLetter[p])
                                                    if(String(guess[m]) == String(RussianLetter[p]))
                                                    {
                                                        RussianColor[p] = 1
                                                    }
                                                }
                                                
                                                
                                            }
                                            
                                            tempPosition += 1
                                            
                                        }
                                        if (row == Int(playTimes-1)*Int(letters) && trueWord == false){ //最後猜錯
                                            print("fw")
                                            showAlert = true
                                            Alertcase = 2
                                        }
                                    }
                                    
                                }
                                
                            }
                            
                            if (inList == false)
                            {
                                print("not in list")
                                showAlert = true
                                Alertcase = 4
                                
                                
                            }else
                            {
                                row += Int(letters)
                                
                            }
                            
                            
                        }else{
                            showAlert = true
                            Alertcase = 3
                        }
                        
                        //need to do
                    } label : {
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .fill(generalColor)
                                .padding(.leading, -4)
                                .frame(width: 40, height: 30)
                            Text("ENTER")
                                .font(.system(size: 11))
                                .padding(.leading, -4)
                                .foregroundColor(wordColor)
                            
                        }}
                    
                    ForEach(24..<33){i in
                        Button{
                            type(i:i)
                        } label : {
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(RussianColor[i] == 0 ? generalColor:RussianColor[i] == 1 ? falseColor : RussianColor[i] == 2 ? falsePlaceColor : trueColor)
                                    .frame(width: 20, height: 30)
                                    .padding(.leading, -4)
                                Text(RussianLetter[i])
                                    .padding(.leading, -4)
                                    .foregroundColor(wordColor)
                                
                            }}.disabled(cantInput)
                    }
                    Button{
                        count -= 1
                        if (row != forward){
                            if (forward > 0){
                                forward -= 1
                                countWord -= 1
                                guessWord[forward] = ""
                                
                            }
                            if (count > 0){
                                count -= 1;
                                
                            }
                            if (count < Int(letters)){
                                cantInput = false
                            }
                        }
                        
                        //need to do
                    } label : {
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .fill(generalColor)
                                .padding(.leading, -4)
                                .frame(width: 40, height: 30)
                            Image(systemName: "delete.left")
                                .font(.system(size: 15))
                                .padding(.leading, -4)
                                .foregroundColor(wordColor)
                            
                        }}
                }
                /*}
                 .offset(x: 5, y: 300)*/
                
                
            }
            
            /*Button{
                showSecondView = true
            }label:{
                VStack{
                    Text("Setting")
                    Image(systemName: "paintbrush.fill")
                    
                }.font(.system(size: 20))
                .padding(.leading, -4)
                .foregroundColor(generalColor)
            }.sheet(isPresented: $showSecondView) {
                SecondView()
                }*/
            VStack{
                HStack{
                    ColorPicker("System color", selection: $generalColor)
                    ColorPicker("word color", selection: $wordColor)
                    
                }
                //頁面位置不夠 暫時不給選
                /*VStack{
                    ColorPicker("in the wrong spot", selection: $falseColor)
                    ColorPicker("not in the word", selection: $falsePlaceColor)
                    ColorPicker("in the correct spot", selection: $trueColor)
                }*/
                Button{
                    var output = ""
                    let wordrange = Int(letters)*Int(playTimes)
                    for i in 0..<wordrange {
                        if (guessColor[i] == 3)
                        {
                            output += "🟩"
                        }else if(guessColor[i] == 1){
                            output += "🟥"
                        }else if(guessColor[i] == 2){
                            output += "🟨"
                        }else{
                            output += "⬛"
                        }
                        
                        if (i % Int(letters) == Int(letters)-1){
                            output += "\n"
                        }
                    }

                    
                    UIPasteboard.general.string = output
                }label:{
                    
                    Text("SHARE")
                        .font(.system(size: 20))
                        .offset(y:10)
                }
                
            }.padding(10)
            

        }.onAppear {
            var fileName : String = ""
            if (Int(letters) == 4)
            {
                fileName = "RussianFourWord"
            }
            else if (Int(letters) == 5)
            {
                fileName = "RussianFiveWord"
            }
            else if (Int(letters) == 6)
            {
                fileName = "RussianSixWord"
            }
            
            if let asset = NSDataAsset(name: fileName),
               let content = String(data: asset.data, encoding: .utf8) {
                array = content.split(separator: "\n")
                randomWord  = String(array.randomElement()!)
                print(randomWord)
            }
        }.alert(isPresented: $showAlert, content: {
            let correct = ["Good job, I’m so proud of you!", "Keep up the good work.", "I know you can do it."].randomElement()!
            let falseMessage = ["Keep fighting, Keep pushing", "What do you have to lose?", " Let me give you a hug. "].randomElement()!
            
            var titleMessage = ""
            var subtitleMessage = ""
            if (Alertcase == 1){
                titleMessage = "Correct"
                subtitleMessage = correct
                //LastGame = Date().timeIntervalSince1970
            }else if (Alertcase == 2){
                titleMessage = randomWord
                subtitleMessage = falseMessage
                //LastGame = Date().timeIntervalSince1970
            }else if(Alertcase == 3){
                titleMessage = "not enough letters"
            }else if(Alertcase == 4){
                titleMessage = "not in word list"
            }
            return Alert(title: Text(titleMessage), message: Text(subtitleMessage))
            
        })
        
    }
}

struct game_Previews: PreviewProvider {
    
    struct gameDemo: View {
        @State var letters: Double = 0
        @State var playTimes: Double = 0
        var body: some View {
            game(letters: letters, playTimes: playTimes)
        }
    }
    @Binding var letters: Double
    @Binding var playTimes: Double
    
    static var previews: some View {
        gameDemo()
    }
}

/*struct SecondView: View {
    @Binding var generalColor : Bool
    @Binding var wordColor : Bool
    @Binding var falseColor : Bool
    @Binding var falsePlaceColor : Bool
    @Binding var trueColor : Bool
    var body: some View {
        VStack {
            ColorPicker("System color", selection: $generalColor)
            ColorPicker("word color", selection: $wordColor)
            ColorPicker("in the wrong spot", selection: $falseColor)
            ColorPicker("not in the word", selection: $falsePlaceColor)
            ColorPicker("in the correct spot", selection: $trueColor)
        }
    }
}*/
