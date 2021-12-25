//
//  ContentView.swift
//  BucketList
//
//  Created by Ifang Lee on 12/24/21.
//

import SwiftUI

struct User: Identifiable, Comparable {
    // equal condition use Equatbale protocol
    static func < (lhs: User, rhs: User) -> Bool { // operator overloading
        lhs.lastName < rhs.lastName
    }

    let id = UUID()
    let firstName: String
    let lastName: String
}

struct ContentView: View {
    let values = [1, 5, 7, 0, 2].sorted()
    let users_not_confront_Comparable_protocol = [
        User(firstName: "Arnold", lastName: "Rimmer"),
        User(firstName: "Kristine", lastName: "Kochanski"),
        User(firstName: "David", lastName: "Listner")
    ].sorted {
        $0.lastName < $1.lastName
    }

    let users_confront_Comparable_protocol = [
        User(firstName: "Arnold", lastName: "Rimmer"),
        User(firstName: "Kristine", lastName: "Kochanski"),
        User(firstName: "David", lastName: "Listner")
    ].sorted()

    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
