import 'dart:html' as html;

String getPlatform() {
  final userAgent = html.window.navigator.userAgent.toLowerCase();
  if (userAgent.contains('iphone') || userAgent.contains('ipad') || userAgent.contains('ipod')) {
    return 'iOS';
  } else if (userAgent.contains('android')) {
    return 'Android';
  } else if (userAgent.contains('mac')) {
    return 'MacOS';
  } else if (userAgent.contains('windows')) {
    return 'Windows';
  } else if (userAgent.contains('linux')) {
    return 'Linux';
  } else {
    return 'Unknown';
  }
}