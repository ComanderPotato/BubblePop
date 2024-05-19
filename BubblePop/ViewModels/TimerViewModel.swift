//
//  TimerViewViewModel.swift
//  BubblePop
//
//  Created by Tom Golding on 2/4/2024.
//
import Combine
import Foundation
// A timer class I made to make my app more extendable 
class TimerViewModel: ObservableObject {
    @Published var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    @Published var totalTime: TimeInterval
    @Published var isActive: Bool = false
    init(totalTime: TimeInterval) {
        self.totalTime = totalTime
    }
    func startTimer() -> Void  {
        self.timer = Timer.publish(every: self.totalTime, on: .main, in: .common).autoconnect()
        self.toggleIsActive()
    }
    func destroyTimer() -> Void {
        self.timer?.upstream.connect().cancel()
    }
    func runTimer() -> Void {
        self.totalTime -= 1
    }
    func decrementTimer() -> Void {
        self.totalTime -= 1
    }
    func pauseTime() -> Void {
        self.totalTime = self.totalTime
    }
    func toggleIsActive() {
        self.isActive = !self.isActive
    }

}
