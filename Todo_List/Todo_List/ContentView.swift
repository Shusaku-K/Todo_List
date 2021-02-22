//
//  ContentView.swift
//  todo
//
//  Created by 金城秀作 on 2021/02/22.
// ユーザー操作
// Todoに追加する場合。
// 1.追加ボタンを押してTodo入力画面へ
// 2.”ここに入力..”の枠に入力して追加ボタンを押す
// 削除する場合。
// 1.右上のEditを押す。
// 2.-ボタンを押すとその１行削除。

import SwiftUI

struct ContentView: View, InputViewDelegate {
    @State var todos: [String] = []
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(todos, id: \.self) { user in
                        Text(user)
                    }
                    .onDelete(perform: delete)
                }
                
                NavigationLink(destination: InputView(delegate: self, text: "")) {
                    Text("追加")
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 20))
                }
                .frame(width: 60, height: 60)
                .background(Color.red)
                .cornerRadius(30)
                .padding()
                
            }
            .onAppear {
                if let todos = UserDefaults.standard.array(forKey: "TODO") as? [String] {
                    self.todos = todos
                }
            }
            .navigationTitle("TODO")
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    func delete(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
        print(todos)
        UserDefaults.standard.setValue(todos, forKey: "TODO")
    }
    
    func addTodo(text: String) {
        todos.append(text)
        UserDefaults.standard.setValue(todos, forKey: "TODO")
    }
}

protocol InputViewDelegate {
    func addTodo(text: String)
}

struct InputView: View {
    @Environment(\.presentationMode) var presentation
    let delegate: InputViewDelegate
    @State var text: String
    var body: some View {
        VStack(spacing: 16) {
            //入力画面の変更はここを修正。
            TextField("ここに入力してください", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("追加する") {
                delegate.addTodo(text: text)
                presentation.wrappedValue.dismiss()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
