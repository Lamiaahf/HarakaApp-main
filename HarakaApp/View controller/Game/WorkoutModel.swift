//
//  WorkoutModel.swift
//  Haraka-AR
//
//  Created by Njood Alhajery on 26/03/2021.
//


import UIKit

struct WorkoutModel {
    
    var name: String = ""
    
    func getWorkoutData() -> [WorkoutModel] {
        var workouts = [WorkoutModel]()
        let workoutNames = Workout.allCases.map({ $0.rawValue })
        for (index, name) in workoutNames.enumerated() {
            let model = WorkoutModel(name: name)
            workouts.append(model)
        }
        return workouts
    }
    
    func getDescription() -> String{
       
        guard let desc = Workout(rawValue: self.name)?.modelDescription
        else { return ""}
        return desc
    }
    
}
