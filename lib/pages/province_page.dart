
import 'package:MzansiCorona/models/country_info.dart';
import 'package:MzansiCorona/providers/logger.dart';
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
import '../apis/corona_api.dart';
import '../models/province_timeline.dart';


/// Province Page.
class ProvincePage extends StatefulWidget {
	final ProvinceInfo provinceInfo;
  final CountryInfo countryInfo;

	ProvincePage(this.provinceInfo, this.countryInfo) {
		assert(this.provinceInfo != null);
		assert(this.countryInfo != null);
	}

	@override
	_ProvincePageState createState() => _ProvincePageState();
}

class _ProvincePageState extends State<ProvincePage> with TickerProviderStateMixin {

  TabController _tabCtrl;
  int _selectedTabIndex = 0;
  int _piechartTouchedIndex;
  final _coronaApi = CoronaApi();
  Future<List<ProvinceTimeline>> _provinceTimelineFuture;

	
	@override
	initState() {
    _tabCtrl = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    );

    //this._provinceTimelineFuture = this._coronaApi.getProvinceTimelineMonths(isoCode: this.widget.provinceInfo.isoCode);
    this._loadProvinceInfo();

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
		final perc = (widget.provinceInfo.numInfections / widget.countryInfo.numInfections) * 100;
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
                  FutureBuilder<List<ProvinceTimeline>>(
                    initialData: [],
                    future: this._provinceTimelineFuture,
                    builder: (BuildContext context, AsyncSnapshot<List<ProvinceTimeline>> snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          margin: EdgeInsets.only(top: 30.0),
                          child: this._renderBasedOnTabIndex(context, snapshot.data)
                        );
                      }
                      else if (snapshot.error) {
                        return Text(snapshot.error);
                      }
                      else {
                        return Container(
                          color: Styles.kColourAppPrimary.withOpacity(0.667),
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Styles.kColourAppTextPrimary,
                            )
                          )
                        ); 
                      }
                    }
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

  Widget _renderBasedOnTabIndex(BuildContext context, List<ProvinceTimeline> data) {
    switch (this._selectedTabIndex) {
      case 0: return this._renderStats(context, data);
      case 1: return this._renderLineGraph(context, data);
      case 2: return this._renderPieChart(context, data);
      default: throw 'Unknown Tab Index: ' + this._selectedTabIndex.toString();
    }
  }

  Widget _renderStats(BuildContext context, List<ProvinceTimeline> data) {
    return Text('stats', style: TextStyle(color: Colors.black),);
  }

  LineChartBarData _createLineChart(List<FlSpot> data, Color colour) {
    final LineChartBarData lineChart = LineChartBarData(
      spots: data,
      isCurved: true,
      colors: [
        colour,
      ],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );

    return lineChart;
  }

  Widget _renderLineGraph(BuildContext context, List<ProvinceTimeline> data) {
    final infections = data.map<FlSpot>((ProvinceTimeline p) {
      return FlSpot(p.updateAt.month.toDouble(), p.numInfections.toDouble());
    }).toList();
    final deaths = data.map<FlSpot>((ProvinceTimeline p) {
      return FlSpot(p.updateAt.month.toDouble(), p.numDeaths.toDouble());
    }).toList();
    final tests = data.map<FlSpot>((ProvinceTimeline p) {
      return FlSpot(p.updateAt.month.toDouble(), p.numTests.toDouble());
    }).toList();
    final recoveries = data.map<FlSpot>((ProvinceTimeline p) {
      return FlSpot(p.updateAt.month.toDouble(), p.numRecovered.toDouble());
    }).toList();

    final infectionsLineChart = this._createLineChart(infections, Styles.kColourInfections);
    final deathsLineChart = this._createLineChart(deaths, Styles.kColourDeaths);
    final testsLineChart = this._createLineChart(tests, Styles.kColourTests);
    final recoveriesLineChart = this._createLineChart(recoveries, Styles.kColourRecoveries);

    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            infectionsLineChart,
            deathsLineChart,
            testsLineChart,
            recoveriesLineChart
          ],
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              textStyle: const TextStyle(
                color: Styles.kColourAppPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              margin: 10,
              getTitles: (double value) {
                return value.toInt().toString();
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              textStyle: const TextStyle(
                color: Styles.kColourAppPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              getTitles: (double value) {
                return '${value.toInt()}';
              },
              margin: 8,
              reservedSize: 30,
            ),
          ),
        )
      ),
    );
  }

  Widget _renderPieChart(BuildContext context, List<ProvinceTimeline> data) {
    final province = this.widget.provinceInfo;
    final total = ((province.numRecovered ?? 0) + (province.numDeaths ?? 0) + (province.numInfections ?? 0) + (province.numTests ?? 0)).toDouble();
    final List<PieChartSectionData> sections = [
      //if ((province.numInfections ?? 0) > 0)
        _pieChartSections((province.numInfections ?? 0) / total, Styles.kColourInfections),
      //if ((province.numTests ?? 0) > 0)
        _pieChartSections((province.numTests ?? 0) / total, Styles.kColourTests),
     // if ((province.numDeaths ?? 0) > 0)
        _pieChartSections((province.numDeaths ?? 0) / total, Styles.kColourDeaths),
     // if ((province.numRecovered ?? 0) > 0)
        _pieChartSections((province.numRecovered ?? 0) / total, Styles.kColourRecoveries),
    ];

    return Column(
      children: [
        PieChart(
          PieChartData(
            pieTouchData: PieTouchData(touchCallback: (PieTouchResponse pieTouchResponse) {
              setState(() {
                if (pieTouchResponse.touchInput is FlLongPressEnd || pieTouchResponse.touchInput is FlPanEnd) {
                  this._piechartTouchedIndex = -1;
                } else {
                  this._piechartTouchedIndex = pieTouchResponse.touchedSectionIndex;
                }
              });
            }),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 40,
            sections: sections,
          ),
        ),

        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Indicator(
              color: Styles.kColourInfections,
              text: 'Infections',
              isSquare: true,
            ),
            SizedBox(
              height: 4,
            ),
            Indicator(
              color: Styles.kColourTests,
              text: 'Tests',
              isSquare: true,
            ),
            SizedBox(
              height: 4,
            ),
            Indicator(
              color: Styles.kColourRecoveries,
              text: 'Recoveries',
              isSquare: true,
            ),
            SizedBox(
              height: 4,
            ),
            Indicator(
              color: Styles.kColourDeaths,
              text: 'Deaths',
              isSquare: true,
            ),
            SizedBox(
              height: 18,
            ),
          ],
        ),
        const SizedBox(
          width: 28,
        ),
      ]
    );
  }

  PieChartSectionData _pieChartSections(double value, Color colour) {
    final isTouched = 1 == this._piechartTouchedIndex;
    final double fontSize = isTouched ? 25 : 16;
    final double radius = isTouched ? 60 : 50;

    return PieChartSectionData(
      color: colour,
      value: value.toDouble(),
      title: value == 0 ? '' : '${value.toStringAsFixed(1)}%',
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Styles.kColourAppTextPrimary
      ),
    );
  }

  void _loadProvinceInfo() {
    this.setState(() {
      this._provinceTimelineFuture = this._coronaApi.getProvinceTimelineMonths(isoCode: this.widget.provinceInfo.isoCode);
    });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key key,
    this.color,
    this.text,
    this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
