//
//  ContentView.swift
//  gameOfLife
//
//  Created by Tony Zhang on 4/17/21.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @State var cells:[[Bool]] = Array(repeating: Array(repeating: false, count: 20), count: 20)
    @State var isPaused = true
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    var items: [GridItem] = Array(repeating: .init(.fixed(12)), count: 20)
    var body: some View {
        LazyVGrid(columns:items,spacing:6){
            ForEach(0 ..< 20) { x in
                ForEach(0 ..< 20) { y in
                    Toggle(isOn: $cells[x][y], label: {})
                }
            }
        }
        .padding()
        .frame(width: 420, height: 420, alignment: .center)
        .background(Color(NSColor.controlBackgroundColor))
        .onReceive(timer) { _ in
            if(!isPaused){
                self.cells = nextStep(cells: cells)
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .automatic){
                Button(action: {
                    isPaused.toggle()
                }, label: {
                    Label(isPaused ? "start" : "pause", systemImage: isPaused ? "play.fill" : "pause.fill")
                })
            }
            ToolbarItem(placement: .automatic){
                Button(action: {
                    isPaused = true
                    cells = Array(repeating: Array(repeating: false, count: 20), count: 20)
                }, label: {
                    Label("reset",systemImage:"backward.end.fill")
                })
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func nextStep(cells:[[Bool]]) -> [[Bool]] {
    var nextCells:[[Bool]] = Array(repeating: Array(repeating: false, count: 20), count: 20)
    for x in 0..<cells.count {
        for y in 0..<cells.count{
            let surroundings = cellSurroundings(cells: cells, x: x, y: y)
            if surroundings == 3{
                nextCells[x][y] = true
            }else if surroundings == 2{
                nextCells[x][y] = cells[x][y]
            }else{
                nextCells[x][y] = false
            }
        }
    }
    
    return nextCells
}

func cellSurroundings(cells:[[Bool]],x:Int,y:Int) -> Int{
    var sum:Int=0
    let xIndexes = [x-1, x,   x+1, x-1, x+1, x-1, x ,x+1]
    let yIndexes = [y-1, y-1, y-1, y,   y,   y+1, y+1, y+1]
    for index in 0..<xIndexes.count{
        if(cells.indices.contains(xIndexes[index])){
            if(cells[xIndexes[index]].indices.contains(yIndexes[index])){
                if(cells[xIndexes[index]][yIndexes[index]]){
                    sum+=1
                }
            }
        }
    }
    return sum
}
