///
/// Marvin Kagiso
/// 18:10 2020/06/06
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
// 

//
// File determines the current environment settings.
// Please do not save this to Version Control.
//



///
/// The Environment config.
/// 
abstract class Env {
  ///
  /// The LIVE environment.
  ///
  static const ENV_LIVE = 'env_live';

  ///
  /// The STAGING environment.
  ///
  static const ENV_STAGING = 'env_staging';

  ///
  /// The LOCAL environment.
  ///
  static const ENV_LOCAL= 'env_local';



  ///
  /// Determines the current environment.
  /// This is the value you'd mostly be working with.
  ///
  static const CURRENT = ENV_LOCAL;

  ///
  /// LIVE App Base URL.
  ///
  static const APP_BASE_URL_LIVE = '/';

  ///
  /// App Base Staging URL.
  ///
  static const APP_BASE_URL_STAGING = '/';

  ///
  /// App Base Local URL.
  ///
  static const APP_BASE_URL_LOCAL = 'http://10.0.2.2:8000/api/';

  ///
  /// The Staging environment base URL.
  ///
  static final APP_BASE_URL = getBasedOnEnv(APP_BASE_URL_LIVE, APP_BASE_URL_STAGING, APP_BASE_URL_LOCAL);


  ///
  /// Checks if current environment is LIVE.
  ///
  static bool isLive() => CURRENT == ENV_LIVE;

  ///
  /// Checks if current environment is LOCAL.
  /// 
  static bool isLocal() => CURRENT == ENV_LOCAL;

  ///
  /// Checks if current environment is STAGING.
  ///
  static bool isStaging() => CURRENT == ENV_STAGING;

  ///
  /// Returns the correct param value based on environment.
  ///
  static dynamic getBasedOnEnv(dynamic live, dynamic staging, dynamic local) {
    switch (CURRENT) {
      case ENV_LIVE: return live;
      case ENV_STAGING: return staging;
      case ENV_LOCAL: return local;
      default: throw 'Undertermined ENV: ' + CURRENT;
    }
  }

  ///
  /// Executes the correct function based on environment.
  ///
  static dynamic exeFuncBasedOnEnv(Function onLive, Function onStaging, Function onLocal) {
    switch (CURRENT) {
      case ENV_LIVE: return onLive();
      case ENV_STAGING: return onStaging();
      case ENV_LOCAL: return onLocal();
      default: throw 'Undertermined ENV: ' + CURRENT;
    }
  }
}
