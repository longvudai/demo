//
//  JournalLayoutAnnouncementViewModel.swift
//  iOS
//
//  Created by longvu on 8/18/21.
//  Copyright © 2021 Peter Vu. All rights reserved.
//

import Foundation
import Combine

class JournalLayoutAnnouncementViewModel: ObservableObject {
    @Published var layout: JournalLayout = .iconLayout
    @Published var selectedLayout: JournalLayout?
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        $selectedLayout
            .compactMap { $0 }
            .sink { newLayout in
                print(newLayout)
            }
            .store(in: &cancellableSet)
    }
}
