///
/// Marvin Kagiso
/// 18:36 2020/06/06
/// 
// This file is part of mzansi_corona.

// mzansi_corona is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// mzansi_corona is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with mzansi_corona.  If not, see <https://www.gnu.org/licenses/>.


import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../models/province_info.dart';


/// Province Info Widget.
class ProvinceInfoWidget extends StatelessWidget {
  final double numTotal;
  final ProvinceInfo info;
  final Function onTap;

  ProvinceInfoWidget({
    @required this.numTotal,
    @required this.info,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = this.info.numInfections / this.numTotal * 100;

    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: onTap ?? null,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.all(15.0),
          height: 200,
          decoration: BoxDecoration(
            color: info.colour,
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircularPercentIndicator(
                  animation: true,
                  radius: 75.0,
                  percent: 0.5,
                  lineWidth: 5.0,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.black26,
                  progressColor: Colors.white,
                  center: Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    this.info.name,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Infections: ${this.info.numInfections}\n'
                    'Deaths: ${this.info.numDeaths}',
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}
