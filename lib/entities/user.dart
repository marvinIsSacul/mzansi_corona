///
/// Marvin Kagiso
/// 10:25 2020/06/15
/// 
/// This file is part of mzansi_corona.

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


import 'package:json_annotation/json_annotation.dart';

import '../helpers/strings.dart';

part 'user.g.dart';


/// The User entity.
@JsonSerializable(explicitToJson: true)
class User {

  static const dateTimeFromString = StringsHelper.dateTimeFromString;


  @JsonKey(name: 'id')  
  String id;

  @JsonKey(name: 'token')
  String token;
  
  @JsonKey(name: 'created_at', fromJson: User.dateTimeFromString)
  DateTime createdAt;

  @JsonKey(name: 'updated_at', fromJson: User.dateTimeFromString)
  DateTime updatedAt;

  @JsonKey(name: 'first_app_version')
  String firstAppVersion;

  @JsonKey(name: 'app_version')
  String appVersion;

  @JsonKey(name: 'device_base_os')
  String deviceBaseOS;

  @JsonKey(name: 'device_os_version')
  String deviceOsVersion;

  @JsonKey(name: 'device_oem')
  String deviceOEM;

  @JsonKey(name: 'device_raw_info')
  Map<String, dynamic> deviceRawInfo;

  User({
    this.id,
    this.token,
    this.createdAt,
    this.updatedAt,
    this.firstAppVersion,
    this.appVersion,
    this.deviceBaseOS,
    this.deviceOsVersion,
    this.deviceOEM,
    this.deviceRawInfo
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
