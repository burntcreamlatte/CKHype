//
//  DateExtension.swift
//  GetHype
//
//  Created by Aaron Shackelford on 12/9/19.
//  Copyright © 2019 Aaron Shackelford. All rights reserved.
//

import Foundation

extension Date {
    func formattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
    }
}
