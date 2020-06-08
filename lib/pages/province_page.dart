
import 'package:MzansiCorona/widgets/back_button.dart';
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

import '../helpers/styles.dart';
import '../widgets/app_menu.dart';
import '../models/province_info.dart';
import '../widgets/top_container.dart';


/// Province Page.
class ProvincePage extends StatefulWidget {
	final ProvinceInfo provinceInfo;

	ProvincePage(this.provinceInfo) {
		assert(this.provinceInfo != null);
	}

	@override
	_ProvincePageState createState() => _ProvincePageState();
}

class _ProvincePageState extends State<ProvincePage> {
	
	@override
	initState() {
		super.initState();
		SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
			statusBarColor: widget.provinceInfo.colour,
			systemNavigationBarColor: widget.provinceInfo.colour,
		));
	}

	@override
	dispose() {
		SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
			statusBarColor: Styles.kColourAppPrimary,
			systemNavigationBarColor: Styles.kColourAppPrimary,
		));
		super.dispose();
	}

	Widget _provinceHeader(BuildContext context) {
		final perc = (widget.provinceInfo.numInfections / 12234323) * 100;

		return TopContainerWidget(
			backgroundImage: widget.provinceInfo.imageUrlMd,
			backgroundColour: widget.provinceInfo.colour,
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
								horizontal: 20.0,
								vertical: 10.0
							),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: <Widget>[
								//_subheading('Provinces'),
							//	SizedBox(height: 5.0),
							//	this._provinces(context),
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
}
