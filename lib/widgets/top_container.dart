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

import '../helpers/styles.dart';

///
/// Top Container Widget.
///
class TopContainerWidget extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  final Color backgroundColour;
  final String backgroundImage;
  final EdgeInsets padding;

  TopContainerWidget({@required this.child, this.backgroundImage, this.backgroundColour, this.height, this.width, this.padding});


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      padding: this.padding ?? EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(

        image: this.backgroundImage == null ? null : DecorationImage(
          image: AssetImage(this.backgroundImage),
          fit: BoxFit.fitWidth
        ),

        color: this.backgroundColour ?? Styles.kColourAppPrimary,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        )
      ),
      height: this.height ?? 164,
      width: this.width ?? screenSize.width,
      child: child,
    );
  }
}
