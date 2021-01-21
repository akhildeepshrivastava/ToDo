//
//  Task.swift
//  ToDo
//
//  Created by Shweta Shrivastava on 1/20/21.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
