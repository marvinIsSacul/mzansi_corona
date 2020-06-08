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
import 'package:flutter_boom_menu/flutter_boom_menu.dart';

import '../helpers/styles.dart';


/// AppMenuWidget.
/// 
class AppMenuWidget extends StatelessWidget {
	//final addonChildren = <{IconData, String}>[];

	@override
	Widget build(BuildContext context) {
		final bgColour = Styles.kColourAppPrimary.withOpacity(0.7);

		return BoomMenu(
			animationSpeed: 167,
			animatedIcon: AnimatedIcons.menu_close,
			animatedIconTheme: IconThemeData(size: 22.0, color: Styles.kColourAppTextPrimary),
			onOpen: () => print('OPENING DIAL'),
			onClose: () => print('DIAL CLOSED'),
			scrollVisible: true,
			overlayColor: Colors.black,
			overlayOpacity: 0.6,
			children: [
				MenuItem(
					child: Icon(Icons.accessibility, color: Styles.kColourAppTextPrimary),
					title: "Profiles",
					titleColor: Styles.kColourAppTextPrimary,
					subtitle: "You Can View the Noel Profile",
					subTitleColor: Colors.white,
					backgroundColor: bgColour,
					onTap: () => print('FIRST CHILD'),
				),
				MenuItem(
					child: Icon(Icons.brush, color: Styles.kColourAppTextPrimary),
					title: "Profiles",
					titleColor: Styles.kColourAppTextPrimary,
					subtitle: "You Can View the Noel Profile",
					subTitleColor: Colors.white,
					backgroundColor: bgColour,
					onTap: () => print('SECOND CHILD'),
				),
				MenuItem(
					child: Icon(Icons.keyboard_voice, color: Styles.kColourAppTextPrimary),
					title: "Profile",
					titleColor: Styles.kColourAppTextPrimary,
					subtitle: "You Can View the Noel Profile",
					subTitleColor: Colors.white,
					backgroundColor: bgColour,
					onTap: () => print('THIRD CHILD'),
				),
				MenuItem(
					child: Icon(Icons.ac_unit, color: Styles.kColourAppTextPrimary),
					title: "Profiles",
					titleColor: Styles.kColourAppTextPrimary,
					subtitle: "You Can View the Noel Profile",
					subTitleColor: Colors.white,
					backgroundColor: bgColour,
					onTap: () => print('FOURTH CHILD'),
				)
			],
		);
	}
}
