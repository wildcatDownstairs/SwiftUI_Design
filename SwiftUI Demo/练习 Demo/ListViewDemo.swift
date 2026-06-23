//
//  ListViewDemo.swift
//  SwiftUI Demo
//
//  Created by 乐可 on 2026/06/21.
//

import SwiftUI

struct User_Info_View: View {
    let name: String
    let email: String
    let phone: String
    let address: String
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                Text("name: \(name)")
                Text("email: \(email)")
                
                GroupBox {
                    VStack(alignment: .leading) {
                        Text("phone: \(phone)")
                        Text("address: \(address)")
                    }
                } label: {
                    Label("Contact Info", systemImage: "person.circle")
                }
                
            }
        } label: {
            Label("User Info", systemImage: "person.crop.circle")
        }.padding(.vertical)
    }
}

struct ContentView: View {

    var body: some View {
        
    }
}

#Preview {
    User_Info_View(
        name: "Jerry",
        email: "1078666705@qq.com",
        phone: "070-4028-2312",
        address: "東京"
    )
}
