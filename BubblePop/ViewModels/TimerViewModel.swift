//
//  TimerViewViewModel.swift
//  BubblePop
//
//  Created by Tom Golding on 2/4/2024.
//
import Combine
import Foundation

class TimerViewModel: ObservableObject {
    @Published var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    @Published var totalTime: TimeInterval = 60
    @Published var isActive: Bool = false
    init() {}
    init(totalTime: TimeInterval) {
        self.totalTime = totalTime
//        self.timer = Timer.publish(every: totalTime, on: .main, in: .common).autoconnect()
        self.isActive = false
    }
    func destroyTimer() {
//        self.timer = self.timer
        
    }
    func setTime(newTime: TimeInterval) {
        self.totalTime = newTime
    }
    func startTimer() {
        self.timer = Timer.publish(every: self.totalTime, on: .main, in: .common).autoconnect()
        self.setIsActive()
    }
    func runTimer() -> Void {
        if(isActive) {
            self.totalTime -= 1
        }
    }
    func pauseTime() -> Void {
        self.totalTime = self.totalTime
    }
    func setIsActive() {
        self.isActive = !self.isActive
    }
}
