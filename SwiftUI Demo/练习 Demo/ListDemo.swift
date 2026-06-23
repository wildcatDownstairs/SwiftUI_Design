//
//  MinimalRoutingDemo.swift
//  SwiftUI Demo
//
//  最简路由示例：仅一个文件、一个 View，演示 NavigationStack 路由三件套
//

import SwiftUI

struct ListViewDemo: View {
    let people: [Person] = [
        .init(name: "Jerry", hobby: "Game", hobbyImage: "gamecontroller.fill"),
        .init(name: "Tom", hobby: "Reading", hobbyImage: "book.fill"),
        .init(name: "Cookie", hobby: "Cooking", hobbyImage: "fork.knife"),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                ForEach(people) { person in
                    RowItem(person: person)
                }
            }
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
    }
}

struct RowItem: View {
    let person: Person

    var body: some View {
        HStack(spacing: 16) {
            if let hobbyImage = person.hobbyImage {
                Image(systemName: hobbyImage)
                    .font(.title2)
                    .foregroundColor(.orange)
                    .frame(width: 44, height: 44)
                    .background(Color.orange.opacity(0.15))
                    .clipShape(Circle())
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(person.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                if let hobby = person.hobby {
                    Text(hobby.capitalized)
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.3))
        }
        .padding()
        .background(Color(white: 0.12))
        .cornerRadius(16)
    }
}

struct Person: Identifiable {
    let id = UUID()
    let name: String
    let hobby: String?
    let hobbyImage: String?
}

#Preview {
    ListViewDemo()
}
