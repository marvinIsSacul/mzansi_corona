
///
/// Marvin Kagiso
/// 18:10 2020/06/06
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
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

import '../helpers/styles.dart';
import '../widgets/app_menu.dart';
import '../models/province_info.dart';
import '../widgets/top_container.dart';
import '../widgets/back_button.dart';


/// Province Page.
class ProvincePage extends StatefulWidget {
	final ProvinceInfo provinceInfo;

	ProvincePage(this.provinceInfo) {
		assert(this.provinceInfo != null);
	}

	@override
	_ProvincePageState createState() => _ProvincePageState();
}

class _ProvincePageState extends State<ProvincePage> with TickerProviderStateMixin {

  TabController _tabCtrl;
  int _selectedTabIndex = 0;
	
	@override
	initState() {
    _tabCtrl = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    );

		super.initState();
		// SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
		// 	statusBarColor: widget.provinceInfo.colour,
		// 	systemNavigationBarColor: widget.provinceInfo.colour,
		// ));
	}

	@override
	dispose() {
		// SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
		// 	statusBarColor: Styles.kColourAppPrimary,
		// 	systemNavigationBarColor: Styles.kColourAppPrimary,
		// ));
		super.dispose();
	}

	Widget _provinceHeader(BuildContext context) {
		final perc = (widget.provinceInfo.numInfections / 12234323) * 100;
    final String provinceBgImage = Styles.provinceImage(widget.provinceInfo);
    final Color provinceColour = Styles.provinceColour(widget.provinceInfo);

		return TopContainerWidget(
			backgroundImage: provinceBgImage,
			backgroundColour: provinceColour,
			child: Container(
					decoration: BoxDecoration(
						color: Colors.black26,
						borderRadius: BorderRadius.all(
							Radius.circular(40.0),
						) 
					),
					child: Column(
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					children: <Widget>[
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: <Widget>[
								BackButtonWidget()
							],
						),
						Padding(
							padding: const EdgeInsets.symmetric(
								horizontal: 0,
								vertical: 0.0
							),
							child: Row(
								crossAxisAlignment: CrossAxisAlignment.center,
								mainAxisAlignment: MainAxisAlignment.spaceEvenly,
								children: <Widget>[
									CircularPercentIndicator(
										radius: 90.0,
										lineWidth: 5.0,
										animation: true,
										percent: perc / 100,
										circularStrokeCap: CircularStrokeCap.round,
										progressColor: Colors.white,
										backgroundColor: Colors.black26,
										center: Text('${perc.toStringAsFixed(1)}%'),
									),

									Container(
										child: Text(
											widget.provinceInfo.name,
											textAlign: TextAlign.start,
											style: TextStyle(
											fontSize: 22.0,
											color: Styles.kColourAppTextPrimary,
											fontWeight: FontWeight.w800,
											),
										),
									),
								],
							),
						)
					]
				)
			),
    );
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			//floatingActionButton: AppMenuWidget(),
			body: SafeArea(
				child: Column(
				children: <Widget>[
					this._provinceHeader(context),
					Expanded(
					child: SingleChildScrollView(
						child: Column(
						children: <Widget>[
							Container(
							color: Colors.transparent,
							padding: EdgeInsets.symmetric(
								horizontal: 8.0,
								vertical: 10.0
							),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: <Widget>[
                  TabBar(
                    controller: this._tabCtrl,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BubbleTabIndicator(
                      indicatorHeight: 25.0,
                      indicatorColor: Styles.kColourAppPrimary,
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    ),
                    labelColor: Styles.kColourAppTextPrimary,
                    isScrollable: false,
                    unselectedLabelColor: Styles.kColourAppSecondary,
                    onTap: (int value) {
                      setState(() {
                        this._selectedTabIndex = value;
                      });
                    },
                    tabs: <Widget>[
                      Text('Stats'),
                      Text('Line'),
                      Text('Pie'),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30.0),
                    child: this._renderBasedOnTabIndex(context)
                  )
								],
							),
							),
						],
						),
					),
					),
				],
				),
			),
		);
	}

  Widget _renderBasedOnTabIndex(BuildContext context) {
    switch (this._selectedTabIndex) {
      case 0: return this._renderStats();
      case 1: return this._renderLineGraph(context);
      case 2: return this._renderPieChart();
      default: throw 'Unknown Tab Index: ' + this._selectedTabIndex.toString();
    }
  }

  Widget _renderStats() {
    return Text('stats', style: TextStyle(color: Colors.black),);
  }

  Widget _renderLineGraph(BuildContext context) {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 1.5),
        FlSpot(5, 1.4),
        FlSpot(7, 3.4),
        FlSpot(10, 2),
        FlSpot(12, 2.2),
        FlSpot(13, 1.8),
      ],
      isCurved: true,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );

    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            lineChartBarData1
          ]
        )
      ),
    );
  }

  Widget _renderPieChart() {
    return Text('pie chart', style: TextStyle(color: Colors.black));
  }
}
