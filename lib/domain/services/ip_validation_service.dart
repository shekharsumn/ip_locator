/// Interface for IP address validation (Interface Segregation Principle)
abstract class IpValidationService {
  /// Validates if the given string is a valid IPv4 or IPv6 address
  bool isValidIpAddress(String ipAddress);

  /// Validates if the given string is a valid IPv4 address
  bool isValidIpv4Address(String ipAddress);

  /// Validates if the given string is a valid IPv6 address
  bool isValidIpv6Address(String ipAddress);

  /// Gets validation error message for invalid IP address
  String? getValidationError(String ipAddress);
}

/// Implementation of IP validation service
class IpValidationServiceImpl implements IpValidationService {
  @override
  bool isValidIpAddress(String ipAddress) {
    return isValidIpv4Address(ipAddress) || isValidIpv6Address(ipAddress);
  }

  @override
  bool isValidIpv4Address(String ipAddress) {
    final ipv4Regex = RegExp(
      r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );
    return ipv4Regex.hasMatch(ipAddress);
  }

  @override
  bool isValidIpv6Address(String ipAddress) {
    // IPv6 validation regex (simplified but covers most common cases)
    final ipv6Regex = RegExp(
      r'^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$|^::1$|^::$|^(?:[0-9a-fA-F]{1,4}:){1,7}:$|^:(?::[0-9a-fA-F]{1,4}){1,7}$|^(?:[0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}$|^(?:[0-9a-fA-F]{1,4}:){1,5}(?::[0-9a-fA-F]{1,4}){1,2}$|^(?:[0-9a-fA-F]{1,4}:){1,4}(?::[0-9a-fA-F]{1,4}){1,3}$|^(?:[0-9a-fA-F]{1,4}:){1,3}(?::[0-9a-fA-F]{1,4}){1,4}$|^(?:[0-9a-fA-F]{1,4}:){1,2}(?::[0-9a-fA-F]{1,4}){1,5}$|^[0-9a-fA-F]{1,4}:(?::[0-9a-fA-F]{1,4}){1,6}$',
    );
    return ipv6Regex.hasMatch(ipAddress);
  }

  @override
  String? getValidationError(String ipAddress) {
    if (ipAddress.trim().isEmpty) {
      return 'IP address cannot be empty';
    }

    if (!isValidIpAddress(ipAddress)) {
      return 'Please enter a valid IPv4 or IPv6 address';
    }

    return null;
  }
}
