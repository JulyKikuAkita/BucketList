//
//  ContentView.swift
//  BucketList
//
//  Created by Ifang Lee on 12/24/21.
//

import SwiftUI

/**
 object-c native encoding: UTF-16
 swift native encoding: UTF-8
 */
struct User: Identifiable, Comparable {
    // equal condition use Equatbale protocol
    static func < (lhs: User, rhs: User) -> Bool { // operator overloading
        lhs.lastName < rhs.lastName
    }

    let id = UUID()
    let firstName: String
    let lastName: String
}

enum LoadingState {
    case loading, success, failed, testing
}

struct LoadingView: View {
    var body: some View {
        Text("Loading")
    }
}

struct SuccessView: View {
    var body: some View {
        Text("Success!")
    }
}

struct FailedView: View {
    var body: some View {
        Text("Failed.")
    }
}

struct TestingView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onTapGesture {
                let str = "Test Message"
                let url = getDocumentsDirectory().appendingPathComponent("message.txt")

                do {//atomically alwasy set to true for for thread safety (write and read the same file at the same time)
                    try str.write(to: url, atomically: true, encoding: .utf8) //TODO: add extention to FileManager
                    let input = try String(contentsOf: url)
                    print(input)
                } catch {
                    print(error.localizedDescription)
                }
            }
    }

    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
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

    var loadingState = LoadingState.success
    var body: some View {
        if loadingState == LoadingState.loading {
            LoadingView()
        } else if loadingState == .success {
            SuccessView()
        } else if loadingState == .failed {
            FailedView()
        } else if loadingState == .testing {
            TestingView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
