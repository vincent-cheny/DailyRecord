//
//  CustomPNPieChart.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/24.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import PNChart

class CustomPNPieChart: PNPieChart {
    
    override func recompute() {
        self.outerCircleRadius = CGRectGetWidth(self.bounds) / 2;
        self.innerCircleRadius = 0
    }
}
