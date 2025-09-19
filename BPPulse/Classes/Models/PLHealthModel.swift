//
//  PLHealthModel.swift
//  BPPulse
//
//  Created by admin on 2025/9/17.
//

import UIKit

enum PLHealthModel: String, CaseIterable {
    case heart, eat, exercise, protect

    var bgIcon: UIImage? {
        switch self {
        case .heart:
            return UIImage(named: "health_heart")
        case .eat:
            return UIImage(named: "health_eat")
        case .exercise:
            return UIImage(named: "health_exercise")
        case .protect:
            return UIImage(named: "health_protect")
        }
    }
    
    var value: String {
        switch self {
        case .heart:
            return "BP Basics"
        case .eat:
            return "Diet"
        case .exercise:
            return "Exercise"
        case .protect:
            return "Lifestyle"
        }
    }
    
    var title: String {
        switch self {
        case .protect:
            return "Understand blood pressure, protect health"
        case .eat:
            return "Diet is related to blood pressure, learn to eat scientifically"
        case .exercise:
            return "Regular exercise, blood pressure is no longer high"
        case .heart:
            return "Stop smoking and limit alcohol to protect heart health"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .protect:
            return UIImage(named: "result_protect")
        case .eat:
            return UIImage(named: "result_eat")
        case .exercise:
            return UIImage(named: "result_exercise")
        case .heart:
            return UIImage(named: "result_heart")
        }
    }
    
    var source: [String] {
        switch self {
        case .heart:
            ["https://www.jacc.org/doi/10.1016/S0735-1097%2802%2981088-9",
            "https://www.jacc.org/doi/10.1016/j.jacasi.2023.02.001"]
        case .eat:
            ["https://www.jacc.org/doi/10.1016/j.jacc.2012.09.010",
            "https://www.jacc.org/doi/10.1016/j.jacc.2017.10.011"]
        case .exercise:
            ["https://www.acsm.org/all-blog-posts/certification-blog/acsm-certified-blog/2020/02/11/blood-pressure-hypertension-exercise-cec-course",
            "https://www.acsm.org/all-blog-posts/acsm-blog/acsm-blog/2017/12/01/new-high-blood-pressure-guidelines"]
        case .protect:
            ["https://en.wikipedia.org/wiki/Hypotension",
            "https://en.wikipedia.org/wiki/Sphygmomanometer"]
        }
    }
    
    var description: String {
        switch self {
        case .protect:
            return """
Understand blood pressure, protect health
With the fast pace and high stress of modern life, paying attention to blood pressure has become an important part of maintaining health. Understanding blood pressure will help us take better care of our bodies and maintain a healthy lifestyle.
First, knowing the normal range of blood pressure is key. Blood pressure is usually expressed as two numbers, such as 120/80 mm Hg. The first number, called systolic blood pressure, reflects how hard the heart pushes the blood when it contracts; The second number is the diastolic blood pressure, which indicates the blood pressure of the heart during diastole. Normal blood pressure should be in the 120/80 MMHG or slightly lower range.
Secondly, maintaining a healthy lifestyle is essential to maintaining normal blood pressure. Moderate exercise is an effective way to lower blood pressure, with at least 150 minutes of aerobic activity a week, such as brisk walking, swimming or cycling. At the same time, controlling weight, limiting salt intake, quitting smoking and limiting alcohol are also key factors in maintaining blood pressure.
In terms of diet, choose foods rich in vegetables, fruits, whole grains and healthy fats to lower cholesterol intake and help maintain cardiovascular health. Increasing the intake of potassium, such as bananas, potatoes and oranges, also has a positive effect on regulating blood pressure.
Regular blood pressure measurement is an important step in health management. Adults are advised to have their blood pressure tested at least once a year, and those with a family history of high blood pressure or other risk factors should be monitored more frequently. Through measurement, blood pressure abnormalities can be detected and controlled in time to reduce the risk of cardiovascular disease.
Under the concept of "understanding blood pressure, protecting health", we are able to better understand our physical condition and adopt an active lifestyle to maintain balance and health in our busy lives. With a healthy diet, exercise and regular blood pressure monitoring, we can protect ourselves from chronic diseases such as high blood pressure.
"""
            
        case .eat:
            return """
Diet is related to blood pressure, learn to eat scientifically
"Diet is related to blood pressure, learn to eat scientifically" is the first rule to maintain cardiovascular health. First of all, it's important to mix food types properly. Increasing intake of fresh vegetables, fruits and whole grains, and reducing foods high in saturated fat and cholesterol can help maintain good blood pressure levels.
Second, controlling food intake is the key to preventing high blood pressure. Moderate food intake can help maintain a healthy weight and reduce the burden on your heart. Small, frequent meals help stabilize blood sugar levels and reduce the need for insulin, which can benefit blood pressure control.
In addition, the rational use of low sodium salt, pay attention to the intake of salt in the diet. A high-salt diet tends to cause water retention in the body and increase blood volume, which raises blood pressure. Choosing herbal spices for flavor reduces the need for added salt to foods and helps maintain healthy blood pressure levels.
Finally, pay attention to when and how you eat. Irregular eating times and binge eating can lead to weight gain and metabolic disorders, increasing the risk of high blood pressure. Therefore, learning to eat scientifically and cultivating good eating habits is an indispensable part of maintaining cardiovascular health. Through a scientific diet, we can effectively prevent high blood pressure and lay a solid foundation for good health.
"""
        case .exercise:
            return """
Regular exercise, blood pressure is no longer high
To maintain good blood pressure levels, regular exercise is an indispensable key. First, getting at least 150 minutes of moderate-intensity aerobic exercise a week, such as brisk walking, swimming or cycling, can help strengthen heart function and lower blood pressure. Exercise makes the heart pump blood more efficiently, reduces the load on the arteries, and lowers systolic and diastolic blood pressure.
Second, emphasize continuous and varied exercise. Continuous exercise, such as jogging or swimming, helps to maintain long-term stability of blood pressure. And a variety of exercises, such as yoga or strength training, can promote overall health and reduce the risk of high blood pressure.
It is also vital to regularly measure blood pressure after exercise to understand the effects of exercise. Blood pressure may rise temporarily after exercise, but it will gradually decrease to a more desirable level after an adjustment period. Monitoring this process can better understand the individual's physiological response and ensure the scientific and safe exercise.
By adhering to regular exercise, we can not only lower blood pressure, but also enhance cardiovascular health and improve the body's endurance and immunity. Therefore, regular exercise has become an indispensable part of the lifestyle to maintain good health and prevent high blood pressure.
"""
        case .heart:
            return """
Stop smoking and limit alcohol to protect heart health
To protect heart health, quitting smoking and limiting alcohol consumption is a key lifestyle adjustment. First, quitting smoking is one of the best ways to reduce your risk of cardiovascular disease. Harmful substances in tobacco cause direct damage to blood vessels, leading to arteriosclerosis, high blood pressure and other problems, increasing the burden on the heart. Quitting smoking not only improves blood circulation, but also reduces the risk of heart disease and stroke.
Second, limiting alcohol intake is also crucial for heart health. While moderate amounts of red wine are thought to have cardiovascular benefits, excessive drinking can lead to high blood pressure, irregular heartbeat and other problems. It is recommended that men consume no more than two drinks a day and women one, while maintaining at least two days of alcohol-free rest.
The combined effects of quitting smoking and limiting alcohol intake far outweigh their individual effects. This lifestyle change not only helps reduce the risk of heart disease, but also improves overall health. By consistently quitting smoking and drinking alcohol in moderation, we can protect our heart health from potential cardiovascular risks and enjoy a longer life.
"""
        }
    }
}
