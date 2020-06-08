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


import 'dart:io' show Platform;
import 'package:flutter/material.dart';


import '../helpers/styles.dart';


/// BackButton Widget.
class BackButtonWidget extends StatelessWidget {
	final Widget colour;
	final IconData icon;

	BackButtonWidget({this.colour, this.icon});

	@override
	Widget build(BuildContext context) {
		return InkWell(
			onTap: (){
				Navigator.pop(context);
			},
			child: Align(
				alignment: Alignment.centerLeft,
				child: Icon(
					this.icon ?? (Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
					size: 25,
					color: this.colour ?? Styles.kColourAppTextPrimary
				),
			),
		);
	}
}
